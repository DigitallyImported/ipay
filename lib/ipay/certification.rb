require 'date'

module IPay
  module Certification
    class << self
      attr_accessor :responses
      
      def log(parsed_xml)
        self.responses ||= ''
        self.responses << parsed_xml.to_s.split("\n")[2...-1].join("\n") + "\n"
      end
    
      def capture(output_path = './')
        IPay.config do |c|
          c.certification = true
        end
    
        yield
      
        save(output_path)
      
        IPay.config do |c|
          c.certification = false
        end
      end
      
      def save(path)
        raise 'Certification mode is not activated' unless IPay.config.certification
        
        file_name = File.join(path, "#{IPay.config.operator}_#{Date.today.to_s.split('-').join}#{Random.new.rand(1..99).to_s.rjust(2, '0')}.xml")
        file = File.open(file_name, 'w')
        
        raise "Failed to open certification file '#{file_name}' for writing" unless file
        file.write("<RESPONSES>\n#{self.responses}</RESPONSES>")
      end
      
    end # self
    
  end
end