module IPay
  module Wallet
    
    def self.default_values(data)
      data[:transaction_indicator] ||= TXN_VIA_HTTPS
      data
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
        self.send_request(data)
      end
    end
    
  end
end