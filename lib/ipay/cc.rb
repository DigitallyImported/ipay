module IPay
  module CC
    
    def self.default_values(data)
      data[:currency_code] ||= 840 # USD
      data[:currency_indicator] ||= CUR_DOMESTIC
      data[:transaction_indicator] ||= TXN_VIA_HTTPS
      data
    end
    
    autoload :Debit, 'ipay/cc/debit'
    autoload :Credit, 'ipay/cc/credit'
  end
end