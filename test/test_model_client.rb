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
      :country => 'United States'
    )
    
    assert @client.valid?
  end
  
  test 'convert country to alpha3' do
    @client = IPay::Client.new :country => 'United States'  
    assert_equal IPay::Countries.alpha3('United States'), @client.country
  end
  
end