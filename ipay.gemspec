lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib) 
require 'ipay/version'

Gem::Specification.new do |s|
  s.name        = 'ipay'
  s.version     = IPay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Nick Wilson'
  s.email       = 'wilson.nick@gmail.com'
  s.homepage    = 'https://github.com/AudioAddict/ipay'
  s.description = 'iPay is a simple library for interfacing with Planet Payments payment solutions API, iPay. For more information visit http://www.ipay.com'
  s.summary     = 'library for interfacing with iPay xml API'
  
  s.require_path  = 'lib'
  s.files         = Dir.glob("{lib,test,example}/**/*") + %w(README.md Rakefile)
  
  s.add_dependency 'libxml-ruby'
  s.add_dependency 'retryable'
  s.add_dependency 'activemodel'
  s.add_dependency 'activesupport'
  s.add_dependency 'countries'
end