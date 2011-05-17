require 'yaml'

module IPay

  module Countries
    @@countries = YAML.load_file(File.join(File.dirname(__FILE__), 'countries.yml'))
    def self.[](key)
      key = key.to_s.downcase.to_sym
      @@countries[key]
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
  
  ACCOUNT_CC  = 'CC'
  ACCOUNT_ACH = 'ACH'
end