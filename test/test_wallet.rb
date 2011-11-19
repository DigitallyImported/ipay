require 'helper'

class TestWallet < Test::Unit::TestCase
  CC_EXP = Date.today.strftime '%m%y'
  
  def create_client
    resp = IPay::Wallet::Client.insert(
      IPay::Client.new({
        :first_name => 'nick', 
        :last_name => 'wilson',
        :address => '123 fake st', 
        :city => 'sometown', 
        :state => 'NY', 
        :postal_code => '90210', 
        :country => 'US'
      }),
      
      IPay::CreditCard.new({
        :account_number => '4000009999999991',
        :cvv => 123,
        :expiration => CC_EXP
      })
    )
  end
  
  test 'client insert' do
    @resp = create_client
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
  end
  
  test 'client modify' do
    
    @resp = create_client
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
    
    sleep(3)
    
    @resp = IPay::Wallet::Client.modify(@resp.data[:client_id], 
      IPay::Client.new(:first_name => 'gregory washington')
    )
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'client delete' do
    @resp = create_client
    
    sleep(3)
    
    @resp = IPay::Wallet::Client.delete @resp.data[:client_id]
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
  end
  
  test 'account insert' do
    @resp = create_client
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
    
    sleep(3)
    
    @resp = IPay::Wallet::Account.insert @resp.data[:client_id], IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 456,
      :expiration => CC_EXP
    })
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'account modify' do
    @resp = create_client
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
    
    sleep(3)
    
    @resp = IPay::Wallet::Account.modify @resp.data[:account_id], IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 987,
      :expiration => CC_EXP
    })
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'account delete' do
    @resp = create_client
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
    
    sleep(3)
    
    @resp = IPay::Wallet::Account.insert @resp.data[:client_id], IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 987,
      :expiration => CC_EXP
    })
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    
    sleep(3)
    
    @resp = IPay::Wallet::Account.delete @resp.data[:account_id]
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
end