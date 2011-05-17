require 'ipay/api_request'

module IPay
  module Currency
   def self.default_values(data)
      {
        :currency_code => IPay::config.defaults[:currency_code],
        :currency_indicator => IPay::config.defaults[:currency_indicator],
        :query_type => QUERY_TYPE_GROUP
      }.merge(data)
    end

    class Rate < ApiRequest
      self.service_format = '0000'

      def self.query(data = {})
        self.send_request(data)
      end
    end

  end
end