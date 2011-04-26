require 'net/https'
require 'uri'
require 'yaml'

module IPay  
  class Request
    
    def initialize(command, data = {})
      @command = command.to_s.split('_').collect{|w| w.upcase}.join('_')
      IPay::log.info "API request: #{@command}"
      
      begin
        template = File.join(File.dirname(__FILE__), 'templates', "#{command.downcase}.yml")
        IPay::log.debug "Loading request template #{template}"
        @data = reorder(data, YAML.load_file(template))
      rescue
        IPay::log.debug 'Failed to load template.'
        @data = data
      end
      
      IPay::log.debug "Request Args: #{(@data.collect { |k, v| "#{k}=#{v}" }.join(','))}" if @data.length > 0
      
      @xml = build_xml("<#{@command}>#{IPay::Util.hash_to_xml(@data)}</#{@command}>")
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
    end
    
    def build_xml(command_xml)
      "<ip_applications_API><api_version>1.0</api_version>
  		<Request>
  			<Authentication>
  				<administrator_login_name>#{IPay::config.username}</administrator_login_name>
  				<password>#{IPay::config.password}</password>
  			</Authentication>
  			<Command>#{command_xml}</Command>
  		</Request>
  		</ip_applications_API>"
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