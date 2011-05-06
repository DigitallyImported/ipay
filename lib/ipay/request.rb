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
      
      res = http.start { |http| http.request(req) }
      res.body
      
      rescue EOFError
        raise RequestError.new('Unable to send your request or the request was rejected by the server.')
    end

    def build_xml(fields_xml)      
      "<REQUEST KEY=\"#{IPay::config.company_key}\" PROTOCOL=\"1\" FMT=\"1\" ENCODING=\"0\">
        <TRANSACTION>
          <FIELDS>
            <TERMINAL_ID>#{IPay::config.terminal_id}</TERMINAL_ID>
            <PIN>#{IPay::config.pin}</PIN>
            #{fields_xml}</FIELDS>
        </TRANSACTION>
      </REQUEST>"
    end
     
  end
end