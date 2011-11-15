require 'yaml'

module IPay
  module Countries
    class << self
      def [](key)
        @@Countries ||= YAML.load_file(File.join(File.dirname(__FILE__), 'countries.yml'))
        @@Countries[key]
      end
      
      def currency_name(key)
        self[key]['currency']['name'] rescue nil
      end
      
      def currency_code(key)
        self[key]['currency']['ipay_code'] rescue nil
      end
    
      def alpha3(key)
        self[key]['alpha3'] rescue nil
      end
    end
  end
  
  EM_SWIPED             = 1
  EM_MANUAL_PRESENT     = 2
  EM_MANUAL_NOT_PRESENT = 3

  GOODS_DIGITAL   = 'D'
  GOODS_PHYSICAL  = 'P'

  CUR_INDICATOR_DOMESTIC  = 0
  CUR_INDICATOR_MCP       = 1
  CUR_INDICATOR_PYC       = 2

  TXN_INDICATOR_MAIL        = 'M'
  TXN_INDICATOR_POS         = 'P'
  TXN_INDICATOR_PHONE       = 'T'
  TXN_INDICATOR_RECUR       = 2
  TXN_INDICATOR_AUTH        = 5
  TXN_INDICATOR_AUTH_FAILED = 6
  TXN_INDICATOR_HTTPS       = 7

  BILLING_TXN_AUTH            = 0
  BILLING_TXN_SALE            = 1
  BILLING_TXN_AVS             = 2
  BILLING_TXN_ACH_VALIDATION  = 3

  ACCOUNT_CC  = 'CC'
  ACCOUNT_ACH = 'ACH'

  QUERY_TYPE_TXN    = 0
  QUERY_TYPE_GROUP  = 1
end