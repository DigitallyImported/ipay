require 'helper'

class TestCC < Test::Unit::TestCase
  CC_EXP = Date.today.strftime '%m%y'
  
  test 'debit sale' do
    resp = IPay::CC::Debit.sale(
      :amount => '4.99', 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'debit auth' do
    resp = IPay::CC::Debit.auth(
      :amount => '4.99', 
      :account_number => '4000009999999991', 
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'debit reversal' do
    resp = IPay::CC::Debit.auth(
      :amount => '4.99', 
      :account_number => '4000009999999991', 
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    sleep(3)
    
    resp = IPay::CC::Debit.reversal(
      :amount => resp.data[:amount], 
      :transaction_id => resp.data[:transaction_id]
    )
    
    assert resp.success?
  end
  
  test 'debit capture' do
    resp = IPay::CC::Debit.auth(
      :amount => '4.99', 
      :account_number => '4000009999999991', 
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    sleep(3)
    
    resp = IPay::CC::Debit.capture(
      :amount => resp.data[:amount], 
      :transaction_id => resp.data[:transaction_id]
    )
    
    assert resp.success?
  end
  
  test 'debit void' do
    resp = IPay::CC::Debit.sale(
      :amount => '4.99', 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    sleep(3)
    
    resp = IPay::CC::Debit.void resp.data[:transaction_id]
    
    assert resp.success?
  end
  
  test 'credit refund' do
    resp = IPay::CC::Credit.refund(
      :amount => '4.99', 
      :account_number => '4000009999999991',
      :cvv => 123, 
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'credit void' do
    resp = IPay::CC::Credit.refund(
      :amount => '4.99', 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210',
      :country => IPay::Currencies.country_code(:us)
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    sleep(3)
    
    resp = IPay::CC::Credit.void resp.data[:transaction_id]
    
    assert resp.success?
  end
  
end