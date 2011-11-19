require 'ipay/model'

module IPay
  class Client < Model
    @humanized_attributes = { :postal_code => 'Zip/Postal Code' }
    
    validates_each [:first_name, :last_name, :address, :city, :state, :postal_code, :country] do |r, a, v|
      r.errors.add a, 'is required' if v.nil? or v.blank?
    end
    
    validates_length_of :country, :is => 3, :message => 'is invalid' # IPay requires alpha3
    
    def initialize(attributes = {})
      if attributes.include?(:country)
        attributes[:country] = (Country[attributes[:country]] && Country[attributes[:country]].alpha3) || attributes[:country]
      end
      
      super
    end
  end
end