#!/usr/bin/env ruby
$:.unshift(File.join(File.dirname(__FILE__),'..', 'lib'))

require 'ipay'
require 'date'
require 'pp'
require 'xml'

CC_EXP = "#{Date.today.month.to_s.rjust(2,'0')}#{Date.today.year.to_s[2..-1]}"
XML_OPTIONS = XML::Parser::Options::NOBLANKS | XML::Parser::Options::NOERROR | XML::Parser::Options::RECOVER | XML::Parser::Options::NOWARNING

xml_output = ''

file_name = "#{IPay::config.operator}_#{Date.today.to_s.split('-').join}#{Random.new.rand(1..99).to_s.rjust(2, '0')}.xml"
file = File.open(file_name, 'w')
raise "Failed to open certification file '#{file_name}' for writing" unless file

def parse_xml(xml)
  parser = XML::Parser.string(xml)
  parser.context.options = XML_OPTIONS
  parser.parse.to_s.split("\n")[2...-1].join("\n") + "\n"
end

resp = IPay::CC::Debit.sale(
  :amount => '4.99', 
  :account_number => '4000009999999991',
  :cvv => 123,
  :expiration => CC_EXP, 
  :first_name => 'nick',
  :last_name => 'wilson',
  :address => '123 fake st', 
  :city => 'sometown', 
  :state => 'NY', 
  :postal_code => '90210', 
  :country => IPay::Countries::USA
)
xml_output << parse_xml(resp.raw_xml)

resp = IPay::CC::Debit.sale(
  :amount => '10.14', 
  :account_number => '4000009999999991',
  :cvv => 123,
  :expiration => CC_EXP, 
  :first_name => 'nick',
  :last_name => 'wilson',
  :address => '123 fake st', 
  :city => 'sometown', 
  :state => 'NY', 
  :postal_code => '90210', 
  :country => IPay::Countries::USA
)
xml_output << parse_xml(resp.raw_xml)

file.write("<RESPONSES>\n#{xml_output}</RESPONSES>")