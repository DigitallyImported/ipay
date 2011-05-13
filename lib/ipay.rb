module IPay
  ENV         = ENV['RAILS_ENV'] || ENV['IPAY_ENV'] || 'development'
  ROOT        = ENV['RAILS_ROOT'] || ENV['IPAY_ROOT'] || '.'
  CONFIG_NAME = 'ipay.yml'
  LOG_NAME    = 'ipay.log'
  
  EM_SWIPED             = 1
  EM_MANUAL_PRESENT     = 2
  EM_MANUAL_NOT_PRESENT = 3

  GOODS_DIGITAL   = 'D'
  GOODS_PHYSICAL  = 'P'

  CUR_DOMESTIC = 0
  CUR_MCP      = 1
  CUR_PYC      = 2

  TXN_VIA_MAIL      = 'M'
  TXN_VIA_POS       = 'P'
  TXN_VIA_PHONE     = 'T'
  TXN_VIA_RECUR     = 2
  TXN_AUTHENTICATED = 5
  TXN_AUTH_FAILED   = 6
  TXN_VIA_HTTPS     = 7
  
  ApiError        = Class.new(RuntimeError)
  RequestError    = Class.new(ApiError)
  RequestTimeout  = Class.new(RequestError)
  ResponseError   = Class.new(ApiError)
  
  
  autoload :CC,       'ipay/cc'
  autoload :Wallet,   'ipay/wallet'
  autoload :Network,  'ipay/network'
end

$:.unshift(File.dirname(__FILE__))
%w[ version config log ].each do |file|
  require "ipay/#{file}"
end