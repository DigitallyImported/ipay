require 'ipay/api_request'

module IPay
  module Wallet
        
    def self.default_values(data)
      {
        :transaction_indicator => IPay.config.defaults[:transaction_indicator]
      }.merge(data)
    end
  
    class Client < ApiRequest
      self.service_format = '1010'
      class << self
        
        def insert(data)
          send_request data
        end

        def modify(data)
          send_request data
        end
        
        def delete(data)
          data = {:client_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
          send_request data
        end
        
        alias :update :modify
      end
    end
  
    class Account < ApiRequest
      self.service_format = '1010'
      class << self
      
        def insert(data)
          send_request data
        end

        def modify(data)
          send_request data
        end

        def delete(data)
          data = {:account_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
          send_request data
        end
        
        alias :update :modify
      end
    end
    
  end
end