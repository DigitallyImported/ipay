require 'ipay/model'
require 'active_support/core_ext/enumerable'

module IPay
  class CreditCard < Model
    InvalidAccountNumberMsg = 'is invalid'
    @humanized_attributes = { :cvv => 'CVV' }
    
    validates_format_of :account_number, :with => /^\d{14,}$/, :message => InvalidAccountNumberMsg
    validates_format_of :expiration, :with => /^\d{4}$/, :message => 'is invalid'
    validates_format_of :cvv, :with => /^\d{3,4}$/, :message => 'is invalid'
    
    validate :luhn_check, :if => lambda { |r| r.attributes.include?(:account_number) }
    
    def initialize(attributes = {})
      attributes[:account_number] = clean_number(attributes[:account_number]) if attributes.include?(:account_number)
      attributes[:account] = ACCOUNT_CC
      super
    end
    
    def clean_number(number)
      number.gsub /\s|\-/, ''
    end
    
    def description
      "#{card_type} #{self.expiration}"
    end
    
    def card_type
      @card_type ||= begin
        case(self.account_number[0...4].to_i)
        when 2014, 2149 then 'EnRoute'
        when 2131, 1800 then 'JCB'
        when 6011       then 'Discover'
        else
          case(self.account_number[0...3].to_i)
          when 300..305 then 'Diners'
          else
            case(self.account_number[0...2].to_i)
            when 34, 37 then 'American Express'
            when 36, 38 then 'Diners'
            when 51..55 then 'Master Card'
            else
              case(self.account_number[0].to_i)
              when 3 then 'JCB'
              when 4 then 'Visa'
              end # 1 digit
            end # 2 digits
          end # 3 digits
        end # 4 digits
      end
    end 
    
    protected
    def luhn_check
      odd = true
      check = self.account_number.to_s.gsub(/\D/,'').reverse.split('').map(&:to_i).collect { |d|
        d *= 2 if odd = !odd
        d > 9 ? d - 9 : d
      }.sum % 10 == 0
      errors.add :account_number, InvalidAccountNumberMsg unless check
    end
    
  end # class
end