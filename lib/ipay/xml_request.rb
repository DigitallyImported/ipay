require 'net/https'
require 'uri'
require 'yaml'
require 'ipay/util'

module IPay
  class XmlRequest
  
    CONFIG_GLOBALS = [:operator, :terminal_id, :pin, :verbose_response]
  
    def initialize(data = {})
      @data = data
      IPay::log.debug "Request Args: #{(@data.collect { |k, v| "#{k}=#{v}" }.join(','))}"
    
      CONFIG_GLOBALS.each do |key|
        next if @data.include?(key)
        @data[key] = IPay::config.send(key) if IPay::config.respond_to?(key)
      end
    
      @xml = build_xml Util::hash_to_xml(@data)
      IPay::log.debug @xml
    end
  
    def to_s
      @xml
    end

    def send
      raise RequestError.new('No iPay API url was specified in your configuration') unless IPay::config.url
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
      raise RequestError.new('No iPay API company_key was specified in your configuration') unless IPay::config.company_key
      "<REQUEST KEY=\"#{IPay::config.company_key}\" PROTOCOL=\"1\" FMT=\"1\" ENCODING=\"0\">
        <TRANSACTION>
          <FIELDS>#{fields_xml}</FIELDS>
        </TRANSACTION>
      </REQUEST>"
    end
   
  end
end