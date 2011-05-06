module IPay
  ENV         = ENV['RAILS_ENV'] || ENV['IPAY_ENV'] || 'development'
  ROOT        = ENV['RAILS_ROOT'] || ENV['IPAY_ROOT'] || '.'
  CONFIG_NAME = 'ipay.yml'
  LOG_NAME    = 'ipay.log'
  
  autoload :CC, 'ipay/cc'
  autoload :Wallet, 'ipay/wallet'
  autoload :Network, 'ipay/network'
end

$:.unshift(File.dirname(__FILE__))
%w[ version config log util errors api_constants request response api_request ].each do |file|
  require "ipay/#{file}"
end