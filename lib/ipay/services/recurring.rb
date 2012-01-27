require 'ipay/api_request'
require 'date'

module IPay
  module Recurring
    
    def self.default_values
      {
        :service => 'RECUR',
        :currency_code => IPay.config.defaults[:currency_code],
        :currency_indicator => IPay.config.defaults[:currency_indicator],
        :transaction_indicator => IPay.config.defaults[:transaction_indicator]
      }
    end
    
    class Client < ApiRequest
      self.service_format = '1010'
      class << self
        
        def insert(client, account, schedule)
          send_request client.merge(account.merge(schedule))
        end

        def modify(client_id, client)
          send_request client.merge :client_id => client_id
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
      
        def insert(client_id, account, schedule)
          send_request account.merge(schedule.merge :client_id => client_id)
        end

        def modify(account_id, account)
          send_request account.merge :account_id => account_id
        end

        def delete(account_id)
          send_request :account_id => account_id
        end
        
        alias :update :modify
      end
    end
    
    class Schedule < ApiRequest
      self.service_format = '1010'
      class << self
      
        def insert(account_id, schedule)
          send_request schedule.merge :account_id => account_id
        end

        def modify(schedule_id, schedule)
          send_request schedule.merge :schedule_id => schedule_id
        end

        def delete(schedule_id, effective_date = nil)
          send_request :schedule_id => schedule_id, :effective_date => (effective_date || Date.today.strftime('%Y%m%d'))
        end
        
        alias :update :modify
        alias :replace :modify
      end
    end

  end
end