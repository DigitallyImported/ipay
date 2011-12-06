require 'ipay/request'
require 'ipay/response'

module IPay
  class ApiRequest
  
    DEFAULT_SERVICE_FORMAT = '0000'
    
    class << self
      attr_writer :service_format
      
      def as_hash(object)
        object.respond_to?(:serializable_hash) ? object.serializable_hash : object
      end
      
      def service_format
        @service_format ||= DEFAULT_SERVICE_FORMAT
      end
      
      def service
        self.name.split('::')[1] rescue nil
      end

      def service_type
        self.name.split('::')[2] rescue nil
      end
  
      def send_request(data = {}, service_subtype = nil)
        data[:service] = self.service.upcase
        data[:service_type] = self.service_type.upcase
        data[:service_subtype] = service_subtype.nil? ? caller[0][/`.*'/][1..-2].upcase : service_subtype.to_s.upcase
        data[:service_format] ||= self.service_format
    
        m = eval("#{self.service}")
        data = m::default_values(data) if m::respond_to?(:default_values)
      
        Request.new(data).send_request
      end 
    
    end # self
    
  end
end