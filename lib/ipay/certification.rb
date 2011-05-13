require 'date'

module IPay
  module Certification
    
    def self.log(parsed_xml)
      @@responses ||= ''
      @@responses << parsed_xml.to_s.split("\n")[2...-1].join("\n") + "\n"
    end
    
    def self.run(output_path = './')
      IPay::config do |c|
        c.certification = true
      end
    
      yield
      
      self.save(output_path)
      
      IPay::config do |c|
        c.certification = false
      end
    end
    
    def self.save(path)
      raise 'Certification mode is not activated' unless IPay::config.certification
      
      file_name = File.join(path, "#{IPay::config.operator}_#{Date.today.to_s.split('-').join}#{Random.new.rand(1..99).to_s.rjust(2, '0')}.xml")
      file = File.open(file_name, 'w')
      raise "Failed to open certification file '#{file_name}' for writing" unless file
      file.write("<RESPONSES>\n#{@@responses}</RESPONSES>")
    end
    
  end
end