require 'helper'

class TestCC < Test::Unit::TestCase
  CC_EXP = "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}"
  
  test 'debit sale' do
    resp = IPay::CC::Debit.sale(
      :amount => '4.99', 
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
  end
  
  test 'debit capture and auth' do
    resp = IPay::CC::Debit.auth(
      :amount => '4.99', 
      :account_number => '4000009999999991', 
      :cvv => 123,
      :expiration => CC_EXP, 
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)
    
    resp = IPay::CC::Debit.capture(
      :amount => '4.99', 
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
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)

    resp = IPay::CC::Debit.void(
      :transaction_id => resp.data[:transaction_id]
    )
    
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
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826
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
      :address => '123 fake &amp; woozle st', 
      :city => 'coram', 
      :state => 'NY', 
      :postal_code => '11727', 
      :country => 826
    )
    
    assert resp.success?
    assert resp.data.include?(:transaction_id)

    resp = IPay::CC::Credit.void(
      :transaction_id => resp.data[:transaction_id]
    )
    
    assert resp.success?
  end
  
end