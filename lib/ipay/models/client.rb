require 'ipay/model'

module IPay
  class Client < Model
    @humanized_attributes = { :postal_code => 'Zip/Postal Code' }
    
    validates_each [:first_name, :last_name, :address, :city, :state, :postal_code, :country] do |r, a, v|
      r.errors.add a, 'is required' if v.nil? or v.blank?
    end
    
    def initialize(attributes = {})
      if attributes.include?(:country)
        attributes[:country] = IPay::Countries.alpha3(attributes[:country]) || attributes[:country]
      end
      
      super
    end
  end
end