#!/usr/bin/env ruby
$:.unshift(File.join(File.dirname(__FILE__),'..', 'lib'))

require 'ipay'
require 'pp'

CC_EXP = "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}"

IPay::log = STDOUT

IPay::config do |c|
  c.url = 'https://uap.txngw.com/'
  c.company_key = 6990
  c.terminal_id = 6177
  c.pin = 1234
end

IPay::Certification.capture do 
  
  resp_auth = IPay::CC::Debit.auth(
  :account_number => '4000009999999991', :cvv => 123, :expiration => CC_EXP, 
  :first_name => 'nick', :last_name => 'wilson', :address => '123 fake st', :city => 'sometown',  :state => 'NY', :postal_code => '90210', :country => IPay::Countries::USA
  )

  resp_sale1 = IPay::CC::Debit.sale(
    :amount => '4.99', 
    :account_number => '4000009999999991', :cvv => 123, :expiration => CC_EXP, 
    :first_name => 'nick', :last_name => 'wilson', :address => '123 fake st', :city => 'sometown',  :state => 'NY', :postal_code => '90210', :country => IPay::Countries::USA
  )

  resp_sale2 = IPay::CC::Debit.sale(
    :amount => '59.99', 
    :account_number => '4000009999999991', :cvv => 123, :expiration => CC_EXP, 
    :first_name => 'nick', :last_name => 'wilson', :address => '123 fake st', :city => 'sometown',  :state => 'NY', :postal_code => '90210', :country => IPay::Countries::USA
  )
  
  sleep(5)
  
  IPay::CC::Debit.void(resp.data[:transaction_id)
  
end