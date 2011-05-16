require 'ipay/api_request'

module IPay
  module CC
  
    def self.default_values(data)
      data[:currency_code] ||= 840 # USD
      data[:currency_indicator] ||= CUR_DOMESTIC
      data[:transaction_indicator] ||= TXN_VIA_HTTPS
      data
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
