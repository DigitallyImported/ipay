require 'net/https'
require 'uri'
require 'yaml'

module IPay  
  class Request
    
    def initialize(data = {})
      @data = data
      IPay::log.debug "Request Args: #{(@data.collect { |k, v| "#{k}=#{v}" }.join(','))}"
      
      @xml = build_xml IPay::Util.hash_to_xml(@data)
      IPay::log.debug @xml
    end
    
    def to_s
      @xml
    end

    def send
      do_post(IPay::config.url, @xml)
    end

    private

    def do_post(api_url, data)
      IPay::log.debug "POST to #{api_url}"
      
      if IPay::config.dry_run
        IPay::log.info 'Dry run enabled, not sending to API'
        return
      end
      
      url = URI.parse(api_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      http.cert_store = store
      
      req = Net::HTTP::Post.new(url.path)
      req.body = data
      
      begin
        res = http.start { |http| http.request(req) }
      rescue EOFError
        raise ResponseError.new('Incomplete response from server')
      end
      res.body
    end
    
    def build_xml(fields_xml)      
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <REQUEST KEY=\"#{IPay::config.company_key}\" PROTOCOL=\"1\" FMT=\"1\" ENCODING=\"0\">
        <TRANSACTION>
          <FIELDS>
            #{fields_xml}
          </FIELDS>
        </TRANSACTION>
      </REQUEST>"
    end

    def reorder(orig, template)
      new_h = {}
      template.each { |k, v|
        next unless orig.has_key? k
        if v.is_a? Hash
          if orig[k].is_a? Array
            new_h[k] = orig[k].collect { |group| reorder(group, template[k]) }
          else
            new_h[k] = reorder(orig[k], template[k])
          end
        else
          new_h[k] = orig[k]
        end
      }
      new_h
    end
    
  end
end