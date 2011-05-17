require 'ipay/api_request'

module IPay
  module Wallet
    
    def self.default_values(data)
      {
        :transaction_indicator => IPay::config.defaults[:transaction_indicator]
      }.merge(data)
    end
  
    class Client < ApiRequest
      self.service_format = '1010'

      def self.insert(data)
        self.send_request(data)
      end

      def self.modify(data)
        self.send_request(data)
      end

      def self.delete(data)
        data = {:client_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
        self.send_request(data)
      end
    end
  
    class Account < ApiRequest
      self.service_format = '1010'

      def self.insert(data)
        self.send_request(data)
      end

      def self.modify(data)
        self.send_request(data)
      end

      def self.delete(data)
         data = {:account_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
        self.send_request(data)
      end
    end
  
  end
end