module IPay
  class CC::Credit < ApiRequest
    self.service_format = '1010'
    
    def self.refund(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= ENTRY_MODE_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
    def self.void(data)
      data[:goods_indicator] ||= GOODS_DIGITAL
      data[:entry_mode] ||= ENTRY_MODE_MANUAL_NOT_PRESENT
      self.send_request(data)
    end
    
  end
end