require 'helper'
#IPay.log = STDOUT

class TestRecurring < Test::Unit::TestCase
  Today = Date.today
  CC_EXP = Today.strftime '%m%y'
  
  def schedule_date(date)
    date.strftime('%Y%m%d')
  end

  def client_data
    IPay::Client.new({
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => 'US'
    })
  end

  def account_data
    IPay::CreditCard.new({
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP
    })
  end

  def schedule_data
    {
      :billing_method => IPay::BILLING_METHOD_POST,
      :schedule_type => IPay::SCHEDULE_NO_END,
      :schedule_start_date => schedule_date(Today),
      :schedule_charge_date => schedule_date(Today >> 6),
      :frequency_type => IPay::FREQUENCY_YEARLY,
      :frequency_month => (Today >> 6).strftime('%b').upcase,
      :frequency_date => (Today >> 6).strftime('%d'),
      :frequency_interval => 1,
      :process_residual => 'N',
      :amount => 1.00
    }
  end

  def create_client
    IPay::Recurring::Client.insert client_data, account_data, schedule_data
  end
  
  test 'client insert' do
    @resp = create_client
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
    assert @resp.data.include?(:account_id)
    assert @resp.data.include?(:schedule_id)
  end
  
  test 'client modify' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    
    sleep 1
    
    @resp = IPay::Recurring::Client.modify(@resp.data[:client_id], 
      IPay::Client.new(:first_name => 'gregory washington')
    )
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'client delete' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")

    sleep 1
    
    @resp = IPay::Recurring::Client.delete @resp.data[:client_id]
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:client_id)
  end
  
  test 'account insert' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    
    sleep 1
    
    @account = IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 456,
      :expiration => CC_EXP
    })

    @resp = IPay::Recurring::Account.insert @resp.data[:client_id], @account, schedule_data
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'account modify' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    
    sleep 1
    
    @resp = IPay::Recurring::Account.modify @resp.data[:account_id], IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 987,
      :expiration => CC_EXP
    })
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'account delete' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    
    sleep 1
    
    @account = IPay::CreditCard.new({
      :account_number => '5100009999999997',
      :cvv => 456,
      :expiration => CC_EXP
    })

    @resp = IPay::Recurring::Account.insert @resp.data[:client_id], @account, schedule_data

    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
    
    sleep 1
    
    @resp = IPay::Recurring::Account.delete @resp.data[:account_id]
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end


  test 'schedule insert' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")

    sleep 1
    
    @resp = IPay::Recurring::Schedule.insert @resp.data[:account_id], schedule_data
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:schedule_id)
  end
  
  test 'schedule modify' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    
    sleep 1
    
    @resp = IPay::Recurring::Schedule.modify @resp.data[:schedule_id], schedule_data
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'schedule delete' do
    @resp = create_client
    assert @resp.success?, @resp.errors.full_messages.join("\n")

    sleep 1
    
    @resp = IPay::Recurring::Schedule.delete @resp.data[:schedule_id]
    
    assert @resp.success?, @resp.errors.full_messages.join("\n")
    assert @resp.data.include?(:transaction_id)
  end

end