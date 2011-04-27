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
  s.description = ''
  s.summary     = 'Ruby gem for interfacing with the iPay XML API'
  
  s.has_rdoc      = false
  s.require_path  = 'lib'
  s.files         = Dir.glob("{lib,test}/**/*") + %w(README.md Rakefile)
  
  s.add_dependency 'libxml-ruby'
end