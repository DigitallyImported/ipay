require 'helper'

class TestModelClient < Test::Unit::TestCase
  CC_EXP = Date.today.strftime '%m%y'
  
  test 'invalid model' do
    @model = IPay::CreditCard.new
    assert_equal false, @model.valid?
  end
  
  test 'valid model' do
    @card = IPay::CreditCard.new(
      :account_number => '4000009999999991',
      :cvv => 123,
      :expiration => CC_EXP
    )
    
    assert @card.valid?
  end
  
  test 'invalid luhn' do
    @card = IPay::CreditCard.new :account_number => '4000009999999992'
    assert_equal false, @card.valid?
    assert @card.errors.include? :account_number
  end
  
  test 'valid luhn' do
    @card = IPay::CreditCard.new :account_number => '4000009999999991', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'Visa', @card.card_type

    @card = IPay::CreditCard.new :account_number => '5100009999999997', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'MasterCard', @card.card_type

    @card = IPay::CreditCard.new :account_number => '370000999999990', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'American Express', @card.card_type
    
    @card = IPay::CreditCard.new :account_number => '6011009999999993', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'Discover', @card.card_type
    
    @card = IPay::CreditCard.new :account_number => '38000099999993', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'Diners', @card.card_type
    
    @card = IPay::CreditCard.new :account_number => '3528009999999996', :expiration => CC_EXP, :cvv => 123
    assert @card.valid?
    assert_equal 'JCB', @card.card_type
  end
  
  test 'invalid cvv format' do
    @card = IPay::CreditCard.new :cvv => '12'
    assert_equal false, @card.valid?
    assert @card.errors.include? :cvv
    
    @card = IPay::CreditCard.new :cvv => '12345'
    assert_equal false, @card.valid?
    assert @card.errors.include? :cvv
  end
  
  test 'valid cvv format' do  
    @card = IPay::CreditCard.new :cvv => '123'
    assert_equal false, @card.valid?
    assert_nil @card.errors.include?(:cvv)
    
    @card = IPay::CreditCard.new :cvv => '1234'
    assert_equal false, @card.valid?
    assert_nil @card.errors.include?(:cvv)
  end
end