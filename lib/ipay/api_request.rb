require 'net/https'
require 'uri'
require 'yaml'

require 'ipay/xml_request'
require 'ipay/response'

module IPay
  class ApiRequest
  
    DEFAULT_SERVICE_FORMAT = '0000'
  
    def self.service_format
      @@service_format ||= DEFAULT_SERVICE_FORMAT
    end
  
    def self.service_format=(val)
      @@service_format = val
    end
  
    def self.service
      self.name.split('::')[1] rescue nil
    end

    def self.service_type
      self.name.split('::')[2] rescue nil
    end
  
    def self.send_request(data = {}, service_subtype = nil)
      data[:service] = self.service.upcase
      data[:service_type] = self.service_type.upcase
      data[:service_subtype] = service_subtype.nil? ? caller[0][/`.*'/][1..-2].upcase : service_subtype.to_s.upcase
      data[:service_format] ||= self.service_format
    
      m = eval("#{self.service}")
      data = m::default_values(data) if m::respond_to?(:default_values)
    
      request = XmlRequest.new(data)  
      Response.new request.send
    end 
    
  end
end