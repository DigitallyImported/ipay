module IPay
  module Wallet
    
    def self.default_values(data)
      data[:transaction_indicator] ||= TXN_VIA_HTTPS
      data
    end
    
    autoload :Client, 'ipay/wallet/client'
  end
end