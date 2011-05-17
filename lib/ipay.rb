module IPay
  ENV         = ENV['RAILS_ENV'] || ENV['IPAY_ENV'] || 'development'
  ROOT        = ENV['RAILS_ROOT'] || ENV['IPAY_ROOT'] || '.'
  CONFIG_NAME = 'ipay.yml'
  LOG_NAME    = 'ipay.log'
  
  ApiError        = Class.new(RuntimeError)
  RequestError    = Class.new(ApiError)
  RequestTimeout  = Class.new(RequestError)
  ResponseError   = Class.new(ApiError)
  
  autoload :CC,       'ipay/cc'
  autoload :Wallet,   'ipay/wallet'
  autoload :Network,  'ipay/network'
  
  autoload :Certification, 'ipay/certification'
end

$:.unshift(File.dirname(__FILE__))
%w[ version constants config log ].each do |file|
  require "ipay/#{file}"
end