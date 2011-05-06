module IPay
  class Network::Status < ApiRequest
    def self.query
      self.send_request
    end
  end
end