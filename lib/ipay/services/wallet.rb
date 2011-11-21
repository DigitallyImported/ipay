require 'ipay/api_request'

module IPay
  module Wallet
        
    def self.default_values(data)
      {
        :transaction_indicator => IPay.config.defaults[:transaction_indicator]
      }.merge(data)
    end
  
    class Client < ApiRequest
      self.service_format = '1010'
      class << self
        
        def insert(client, account, txn_type = BILLING_TXN_AVS)
          data = {:billing_transaction => txn_type}.merge( as_hash(client).merge as_hash(account) )
          send_request data
        end

        def modify(client_id, client)
          send_request as_hash(client).merge :client_id => client_id
        end
        
        def delete(client_id)
          send_request :client_id => client_id
        end
        
        alias :update :modify
      end
    end
  
    class Account < ApiRequest
      self.service_format = '1010'
      class << self
      
        def insert(client_id, account, txn_type = BILLING_TXN_AVS)
          send_request as_hash(account).merge :billing_transaction => txn_type, :client_id => client_id
        end

        def modify(account_id, account)
          send_request as_hash(account).merge :account_id => account_id
        end

        def delete(account_id)
          send_request :account_id => account_id
        end
        
        alias :update :modify
      end
    end
    
  end
end