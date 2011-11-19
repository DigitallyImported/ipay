require 'helper'

class TestModelClient < Test::Unit::TestCase

  test 'invalid client' do
    @client = IPay::Client.new
    assert_equal false, @client.valid?
  end
  
  test 'valid client' do
    @client = IPay::Client.new(
      :first_name => 'nick', 
      :last_name => 'wilson',
      :address => '123 fake st', 
      :city => 'sometown', 
      :state => 'NY', 
      :postal_code => '90210', 
      :country => 'USA'
    )
    
    assert @client.valid?
  end
  
  test 'convert alpha2 to alpha3' do
    @client = IPay::Client.new :country => 'US'  
    assert_equal Country['US'].alpha3, @client.country
  end
  
end