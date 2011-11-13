require 'ipay/api_request'

module IPay
  module CC
    def self.default_values(data)
      {
        :currency_code => IPay.config.defaults[:currency_code],
        :currency_indicator => IPay.config.defaults[:currency_indicator],
        :transaction_indicator => IPay.config.defaults[:transaction_indicator]
      }.merge(data)
    end
    
    class Credit < ApiRequest
      self.service_format = '1010'
      class << self
        
        def refund(data)
          send_request data
        end

        def void(data)
          data = {:transaction_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
          send_request data
        end
        
      end
    end
  
    class Debit < ApiRequest
      self.service_format = '1010'
      class << self
        
        def auth(data)
          data[:goods_indicator] ||= GOODS_DIGITAL
          send_request data
        end

        def capture(data)
          send_request data
        end

        def sale(data)
          data[:goods_indicator] ||= GOODS_DIGITAL
          data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
          
          send_request data
        end

        def void(data)
          data = {:transaction_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
           send_request data
        end
      
        def reversal(data)
          send_request data
        end
        
      end
    end
  
  end
end