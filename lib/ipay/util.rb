module IPay
  module Util
  
    def self.hash_to_xml(h, l=0)
      return h.to_s unless h.is_a? Hash
      xml = ''
      h.each do |k,v|
        k = k.to_s.upcase
        xml << if v.kind_of? Enumerable
          (v.is_a?(Array) ? v : Array[v]).collect { |group| "#{"\t"*l}<#{k}>\n#{hash_to_xml(group, l+1)}#{"\t"*l}</#{k}>\n"}.join
        else
          "#{"\t"*l}<#{k}>#{v}</#{k}>\n"
        end
      end
      xml
    end
    
  end
end