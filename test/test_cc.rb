require 'helper'

class TestCC < Test::Unit::TestCase
  CC_EXP = Date.today.strftime '%m%y'

  def cc_data
    {
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP,
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st',
      :city => 'sometown',
      :state => 'NY',
      :postal_code => '90210',
      :country => 'USA'
    }
  end

  def do_sale(amount)
    IPay::CC::Debit.sale(cc_data.merge(:amount => amount))
  end
  
  def do_auth(amount)
    IPay::CC::Debit.auth(cc_data.merge(:amount => amount))
  end

  test 'debit sale' do
    @resp = do_sale(4.99)
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'debit auth' do
    @resp = do_auth(4.99)

    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'debit reversal' do
    @resp = do_auth(4.99)
    assert @resp.success?

    sleep 2

    @resp = IPay::CC::Debit.reversal @resp.data[:transaction_id], @resp.data[:amount]
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'debit capture' do
    @resp = do_auth(4.99)
    assert @resp.success?
    
    sleep 2
    
    @resp = IPay::CC::Debit.capture @resp.data[:transaction_id], @resp.data[:amount]

    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
  test 'debit void' do
    @resp = do_sale(4.99)
    assert @resp.success?

    sleep 2
    
    @resp = IPay::CC::Debit.void @resp.data[:transaction_id]
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
  
end