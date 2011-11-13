#!/usr/bin/env ruby
$:.unshift(File.join(File.dirname(__FILE__),'..', 'lib'))

require 'ipay'

IPay.log = STDOUT
IPay.config do |c|
  c.url = 'https://uap.txngw.com/'
  c.company_key = 6990
  c.terminal_id = 6177
  c.pin = 1234
  c.verbose_respone = 1
end

cc = { :account_number => '4000009999999991', :cvv => 123, :expiration => "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}" }
address = { :first_name => 'nick', :last_name => 'wilson', :address => '123 fake st', :city => 'sometown',  :state => 'NY', :postal_code => '90210', :country => IPay::Currencies[:us][:country_code] }
wallet_acct = {:account => IPay::ACCOUNT_CC, :billing_transaction => IPay::BILLING_TXN_AVS }.merge(cc)

IPay::Certification.capture do 
  
  IPay::CC::Debit.auth({:amount => '0.99'}.merge(cc.merge address))
  resp_auth = IPay::CC::Debit.auth({:amount => '4.99'}.merge(cc.merge address))
  resp_sale = IPay::CC::Debit.sale({:amount => '4.99', :currency_code => IPay::Currencies.currency_code(:eu), :currency_indicator => IPay::CUR_INDICATOR_MCP}.merge(cc.merge address))
  resp_sale2 = IPay::CC::Debit.sale({:amount => '59.99'}.merge(cc.merge address))
  resp_sale3 = IPay::CC::Debit.sale({:amount => '19.99'}.merge(cc.merge address))
  
  # give the transactions a few seconds to process internally
  sleep(5)
  
  IPay::CC::Debit.void resp_auth.data[:transaction_id]
  IPay::CC::Debit.void resp_sale.data[:transaction_id]
  
  IPay::CC::Credit.refund({:transaction_id => resp_sale2.data[:transaction_id], :amount => '4.99', :currency_code => IPay::Currencies.currency_code(:eu), :currency_indicator => IPay::CUR_INDICATOR_MCP}.merge(cc.merge address))
  IPay::CC::Credit.refund({:transaction_id => resp_sale3.data[:transaction_id], :amount => '59.99'}.merge(cc.merge address))
  
  resp_refund = IPay::CC::Credit.refund({:amount => '4.99', :currency_code => IPay::Currencies.currency_code(:eu), :currency_indicator => IPay::CUR_INDICATOR_MCP}.merge(cc.merge address))
  resp_refund2 = IPay::CC::Credit.refund({:amount => '59.99'}.merge(cc.merge address))
  
  sleep(5)
  
  IPay::CC::Credit.void resp_refund.data[:transaction_id]
  IPay::CC::Credit.void resp_refund2.data[:transaction_id]
    
  resp_wallet = IPay::Wallet::Client.insert(wallet_acct.merge address)
  resp_wallet2 = IPay::Wallet::Client.insert(wallet_acct.merge address)
  
  sleep(5)
  
  IPay::Wallet::Client.modify( :client_id => resp_wallet.data[:client_id], :phone => '555-123-4567' )
  IPay::Wallet::Client.modify( :client_id => resp_wallet2.data[:client_id], :member_number => '42' )
  
  resp_acct = IPay::Wallet::Account.insert({:client_id => resp_wallet.data[:client_id]}.merge(wallet_acct.merge cc))
  resp_acct2 = IPay::Wallet::Account.insert({:client_id => resp_wallet.data[:client_id]}.merge(wallet_acct.merge cc))
  
  sleep(5)
  
  IPay::Wallet::Account.modify( :account_id => resp_acct.data[:account_id], :account_number => '5100009999999997' )
  IPay::Wallet::Account.modify( :account_id => resp_acct2.data[:account_id], :account_number => '5100009999999997' )
  
  IPay::Wallet::Account.delete resp_acct.data[:account_id]
  IPay::Wallet::Account.delete resp_acct2.data[:account_id]
  
  IPay::Wallet::Client.delete resp_wallet.data[:client_id]
  IPay::Wallet::Client.delete resp_wallet2.data[:client_id]
  
end