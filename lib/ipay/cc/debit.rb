module IPay
  class CC::Debit < ApiRequest
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
      self.send_request(data)
    end
    
  end
end