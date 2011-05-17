require 'helper'

class TestWallet < Test::Unit::TestCase
  CC_EXP = "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}"
  
  test 'client insert' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
  end
  
  test 'client modify' do
    
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Client.modify(
      :client_id => resp.data[:client_id],
      :first_name => 'gregory washington'
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'client delete' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Client.delete resp.data[:client_id]
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
  end
  
  test 'account insert' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Account.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => '0512', 
      :client_id => resp.data[:client_id]
    )
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'account modify' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Account.modify(
      :account_id => resp.data[:account_id],
      :billing_transaction => 2, 
      :account_number => '5100009999999997',
      :cvv => 456,
      :expiration => CC_EXP
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'account delete' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Countries.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Account.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => '0512', 
      :client_id => resp.data[:client_id]
    )
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    sleep(3)
    
    resp = IPay::Wallet::Account.delete resp.data[:account_id]
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
end