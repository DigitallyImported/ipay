require 'helper'

class TestRepository < Test::Unit::TestCase
  def create_product
    IPay::Repository::Product.insert({
      :product_name => 'Premium Radio',
      :product_description => 'High Quality, Commercial Free Radio'
    })
  end
  
  test 'product insert' do
    @resp = create_product
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:product_id)
  end
  
  test 'product modify' do
    @resp = create_product
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:product_id)
    
    sleep(3)
    
    @resp = IPay::Repository::Product.modify(@resp.data[:product_id],
      { :product_description => 'Test' }
    )

    assert @resp.success?
    assert_equal 'Test', @resp.data[:product_description]
  end
  
  test 'product delete' do
    @resp = create_product
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
    assert @resp.data.include?(:product_id)
    
    sleep(3)
    
    @resp = IPay::Repository::Product.delete @resp.data[:product_id]
    
    assert @resp.success?
    assert @resp.data.include?(:transaction_id)
  end
end