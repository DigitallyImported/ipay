require 'ipay/api_request'

module IPay
  module Network
  
    class Status < ApiRequest
      def self.query
        self.send_request
      end
    end
  
  end
end