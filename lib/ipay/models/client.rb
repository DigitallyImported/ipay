require 'ipay/model'

module IPay
  class Client < Model
    validates_each [:first_name, :last_name, :address, :city, :state, :postal_code, :country] do |r, a, v|
      r.errors.add a, 'cannot be blank' if v.nil? or v.blank?
    end
    
    validates_length_of :country, :is => 3, :message => 'not a valid 3 letter ISO Country Code'
    
    def initialize(attributes = {})
      if attributes.include?(:country) && attributes[:country].is_a?(Symbol)
        attributes[:country] = IPay::Currencies.country_code(attributes[:country])
      end
      
      super attributes
    end
  end
end