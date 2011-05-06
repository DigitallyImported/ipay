module IPay
  class CC::Debit < ApiRequest
    self.service_format = '1010'
    
    def self.auth(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
    def self.capture(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
    def self.sale(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
    def self.void(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= EM_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
  end
end