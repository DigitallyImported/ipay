module IPay
  ENV         = ENV['RAILS_ENV'] || ENV['IPAY_ENV'] || 'development'
  ROOT        = ENV['RAILS_ROOT'] || ENV['IPAY_ROOT'] || '.'
  CONFIG_NAME = 'ipay.yml'
  LOG_NAME    = 'ipay.log'
  
  ApiError      = Class.new(RuntimeError)
  RequestError  = Class.new(ApiError)
  ResponseError = Class.new(ApiError)
end

$:.unshift(File.dirname(__FILE__))
%w[ version config log util request response api ].each do |file|
  require "ipay/#{file}"
end