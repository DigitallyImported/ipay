require 'ipay'
require 'test/unit'
require 'date'

class Test::Unit::TestCase
  def self.test(string, &block)
    define_method("test:#{string}", &block)
  end
  
  def assert_not(expression)
    assert_block("Expected <#{expression}> to be false!") { not expression }
  end
end