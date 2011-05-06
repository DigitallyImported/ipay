module IPay
  class CC::Credit < ApiRequest
    self.service_format = '1010'
    
    def self.refund(data)
      self.send_request(data)
    end
    
    def self.void(data)
      self.send_request(data)
    end
    
  end
end