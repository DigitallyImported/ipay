require 'net/https'
require 'uri'
require 'retryable'
require 'ipay/util'

module IPay
  class Request
  
    CONFIG_GLOBALS = [:operator, :terminal_id, :pin, :verbose_response]
  
    def initialize(data = {})
      @data = data
    
      CONFIG_GLOBALS.each do |key|
        next if @data.include?(key)
        @data[key] = IPay.config.send(key) if IPay.config.respond_to?(key)
      end
    
      @xml = build_xml Util::hash_to_xml(@data)
      IPay.log.debug @xml
    end
  
    def to_s
      @xml
    end

    def send_request
      raise RequestError.new('No iPay API url was specified in your configuration') unless IPay.config.url
      retryable(:tries => IPay.config.retries, :on => RetryRequest) do
        Response.new post(IPay.config.url, @xml)
      end
    end

    protected
    
    def post(api_url, data)
      IPay.log.info "POST to #{api_url}"
      IPay.log.info('Dry run enabled, not sending to API') and return if IPay.config.dry_run
      
      url = URI.parse(api_url)
      url.path ='/' if url.path.empty?
      
      http = Net::HTTP.new(url.host, url.port)
      http.set_debug_output(HttpDebug.new)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      http.cert_store = store
      
      req = Net::HTTP::Post.new(url.path, 'User-Agent' => "AudioAddict/iPay v#{IPay::VERSION}")
      res = http.start { |http| http.request(req, data) }

      res.body
      
      rescue EOFError, Errno::ECONNREFUSED, Errno::ECONNRESET => e
        IPay.log.error e
        raise ServiceUnavailableError.new("Unable to send your request or the request was rejected by the server: #{e}")
    end

    def build_xml(fields_xml)      
      raise RequestError.new('No iPay API company_key was specified in your configuration') unless IPay.config.company_key
      "<REQUEST KEY=\"#{IPay.config.company_key}\" PROTOCOL=\"1\" FMT=\"1\" ENCODING=\"0\">
        <TRANSACTION>
          <FIELDS>#{fields_xml}</FIELDS>
        </TRANSACTION>
      </REQUEST>"
    end
   
  end
end