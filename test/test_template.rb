require 'helper'

class TestTemplate < Test::Unit::TestCase

  def create_product
    IPay::Repository::Product.insert({
      :product_name => 'Premium Radio',
      :product_description => 'High Quality, Commercial Free Radio'
    })
  end

  def create_billing
    @product = create_product

    IPay::Template::Billing.insert({
      :billing_name => 'Premium Radio Subscription',
      :product_id => @product.data[:product_id]
    })
  end
  
  test 'billing insert' do
    @resp = create_billing
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:billing_id)
  end
  
  test 'Billing modify' do
    @resp = create_billing
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:billing_id)
    
    sleep(3)
    
    @resp = IPay::Template::Billing.modify(@resp.data[:billing_id],
      { :billing_name => 'Test' }
    )

    assert @resp.success?
    assert_equal 'Test', @resp.data[:billing_name]
  end
  
  test 'Billing delete' do
    @resp = create_billing
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:billing_id)
    
    sleep(3)
    
    @resp = IPay::Template::Billing.delete @resp.data[:billing_id]
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
end