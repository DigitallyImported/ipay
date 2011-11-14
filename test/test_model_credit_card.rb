require 'helper'

class TestModelClient < Test::Unit::TestCase
  CC_EXP = Date.today.strftime '%m%y'
  
  test 'invalid model' do
    @model = IPay::CreditCard.new
    assert_equal false, @model.valid?
  end
  
  test 'valid model' do
    @client = IPay::CreditCard.new(
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP
    )
    
    assert @client.valid?
  end
  
  test 'invalid luhn' do
    @client = IPay::CreditCard.new :account_number => '4000009999999992'
    assert_equal false, @client.valid?
    assert @client.errors.include? :account_number
  end
  
  test 'valid luhn' do
    @client = IPay::CreditCard.new :account_number => '4000009999999991', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'Visa', @client.card_type

    @client = IPay::CreditCard.new :account_number => '5100009999999997', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'Master Card', @client.card_type

    @client = IPay::CreditCard.new :account_number => '370000999999990', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'American Express', @client.card_type
    
    @client = IPay::CreditCard.new :account_number => '6011009999999993', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'Discover', @client.card_type
    
    @client = IPay::CreditCard.new :account_number => '38000099999993', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'Diners', @client.card_type
    
    @client = IPay::CreditCard.new :account_number => '3528009999999996', :expiration => CC_EXP
    assert @client.valid?
    assert_equal 'JCB', @client.card_type
  end
  
  test 'invalid cvv format' do
    @client = IPay::CreditCard.new :cvv => '12'
    assert_equal false, @client.valid?
    assert @client.errors.include? :cvv
    
    @client = IPay::CreditCard.new :cvv => '12345'
    assert_equal false, @client.valid?
    assert @client.errors.include? :cvv
  end
  
  test 'valid cvv format' do  
    @client = IPay::CreditCard.new :cvv => '123'
    assert_equal false, @client.valid?
    assert_nil @client.errors.include?(:cvv)
    
    @client = IPay::CreditCard.new :cvv => '1234'
    assert_equal false, @client.valid?
    assert_nil @client.errors.include?(:cvv)
  end
end