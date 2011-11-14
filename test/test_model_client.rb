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
      :country => :us
    )
    
    assert @client.valid?
  end
  
  test 'invalid country code' do
    @client = IPay::Client.new :country => 'not valid'
    
    assert_equal false, @client.valid?
    assert @client.errors.include? :country
  end
  
  test 'convert country to iso code' do
    @client = IPay::Client.new :country => :us
    
    assert_equal IPay::Currencies.country_code(:us), @client.country
  end
  
end