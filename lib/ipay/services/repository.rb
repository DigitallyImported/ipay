require 'ipay/api_request'

module IPay
  module Repository

    class Product < ApiRequest
      self.service_format = '0000'

      class << self
        
        def insert(data)
          send_request data
        end

        def modify(product_id, data)
          send_request data.merge(:product_id => product_id)
        end

        def delete(product_id)
          send_request :product_id => product_id
        end

      end
    end

  end
end