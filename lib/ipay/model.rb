require 'active_model'

module IPay
  class Model
    include ActiveModel::Validations
    include ActiveModel::Serialization
    
    attr_accessor :attributes
    attr_accessor :skip_validations
    
    def initialize(attributes = {}, skip_validations = false)
      @attributes = attributes
      @skip_validations = skip_validations
    end
    
    def read_attribute_for_validation(key)
      @attributes[key]
    end
    
    def method_missing(*m)
      case(m.length)
      when 1
        return @attributes[m[0]] if @attributes.include?(m[0])
      when 2
        return @attributes[m[0][0...-1].to_sym] = m[1]
      end
      
      super *m
    end
    
  protected
    def run_validations!
      @skip_validations ? true : super
    end
   
    def self.human_attribute_name(attr, opt = {})
      (defined?(@humanized_attributes) && @humanized_attributes[attr.to_sym]) || super
    end
    
  end
end