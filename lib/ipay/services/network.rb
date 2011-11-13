require 'ipay/api_request'

module IPay
  module Network
  
    class Status < ApiRequest
      class << self
        
        def query
          send_request
        end
        
      end
    end
  
  end
end