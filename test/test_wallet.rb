require 'helper'

class TestWallet < Test::Unit::TestCase
  test 'client insert' do
    resp = IPay::Wallet::Client.insert(
      :account => 'CC',
      :billing_transaction => 2, 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => '0512', 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826,
      :operator => 'AudioAddict',
      :verbose_response => 1 
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
      :expiration => '0512', 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826,
      :operator => 'AudioAddict',
      :verbose_response => 1 
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    resp = IPay::Wallet::Client.modify(
      :client_id => resp.data[:client_id],
      :first_name => 'gregory washington',
      :operator => 'AudioAddict',
      :verbose_response => 1 
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
      :expiration => '0512', 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826,
      :operator => 'AudioAddict',
      :verbose_response => 1 
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
    
    resp = IPay::Wallet::Client.delete(
      :client_id => resp.data[:client_id],
      :operator => 'AudioAddict',
      :verbose_response => 1 
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    assert resp.data.include?(:client_id)
  end
  
  test 'account insert' do
    flunk
  end
  
  test 'account modify' do
    flunk
  end
  
  test 'account delete' do
    flunk
  end
end