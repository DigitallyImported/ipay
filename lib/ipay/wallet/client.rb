module IPay
  class Wallet::Client < ApiRequest
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