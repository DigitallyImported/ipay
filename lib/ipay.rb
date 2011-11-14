module IPay
  ENV         = (defined?(Rails) && Rails.env) || ENV['RACK_ENV'] || ENV['IPAY_ENV'] || 'development'
  ROOT        = (defined?(Rails) && Rails.root) || ENV['IPAY_ROOT'] || ::File.expand_path('.')
  CONFIG_NAME = 'ipay.yml'
  LOG_PREFIX  = 'ipay'
  
  autoload :Certification,  'ipay/certification'
  
  autoload :CC,       'ipay/services/cc'
  autoload :Wallet,   'ipay/services/wallet'
  autoload :Currency, 'ipay/services/currency'
  autoload :Network,  'ipay/services/network'
  
  autoload :Client,     'ipay/models/client'
  autoload :CreditCard, 'ipay/models/credit_card'
end

$:.unshift(File.dirname(__FILE__))
%w[ errors version constants config log ].each do |file|
  require "ipay/#{file}"
end