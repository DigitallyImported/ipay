require 'ipay/api_request'

module IPay
  module CC
  
    def self.default_values(data)
      {
        :currency_code => IPay::config.defaults[:currency_code],
        :currency_indicator => IPay::config.defaults[:currency_indicator],
        :transaction_indicator => IPay::config.defaults[:transaction_indicator]
      }.merge(data)
    end
  
    class Credit < ApiRequest
      self.service_format = '1010'

      def self.refund(data)
        self.send_request(data)
      end

      def self.void(data)
        data = {:transaction_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
        self.send_request(data)
      end
    end
  
    class Debit < ApiRequest
      self.service_format = '1010'

      def self.auth(data)
        data[:goods_indicator] ||= GOODS_DIGITAL
        self.send_request(data)
      end

      def self.capture(data)
        self.send_request(data)
      end

      def self.sale(data)
        data[:goods_indicator] ||= GOODS_DIGITAL
        data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
        self.send_request(data)
      end

      def self.void(data)
        data = {:transaction_id => data} if data.is_a?(String) || data.is_a?(Fixnum)
        self.send_request(data)
      end
    end
  
  end
end
