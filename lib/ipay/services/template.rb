require 'ipay/api_request'

module IPay
  module Template

    class Billing < ApiRequest
      self.service_format = '0000'

      class << self
        
        def insert(data)
          send_request data
        end

        def modify(billing_id, data)
          send_request data.merge(:billing_id => billing_id)
        end

        def delete(billing_id)
          send_request :billing_id => billing_id
        end

      end
    end

  end
end