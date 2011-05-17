require 'helper'

class TestErrors < Test::Unit::TestCase
  CC_EXP = "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}"
  
  test 'sale declined' do
  
    resp = IPay::CC::Debit.sale(
      :amount => '1.05', 
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
  
    assert resp.error?
    assert resp.status[:arc] == '05'
  
  end

  test 'request timeout' do
  
    assert_raise IPay::RequestTimeout do
      resp = IPay::CC::Debit.sale(
        :amount => '1.57', 
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
    end
      
  end
  
end