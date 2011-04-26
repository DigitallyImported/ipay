module IPay
  module Util
  
    def self.hash_to_xml(h, l=0)
      return h.to_s unless h.is_a? Hash
      xml = ''
      h.each do |k,v|
      xml << if v.kind_of? Enumerable
          k = k.to_s.split('_').collect {|w| w.capitalize}.join('_')
          (v.is_a?(Array) ? v : Array[v]).collect { |group| "#{"\t"*l}<#{k}>\n#{hash_to_xml(group, l+1)}#{"\t"*l}</#{k}>\n"}.join
        elsif v.is_a? IPay::Flag
          k = k.to_s.split('_').collect{|w| w.upcase}.join('_')
          "#{"\t"*l}<#{k}>#{hash_to_xml(v.value, l+1)}</#{k}>\n"
        else
          "#{"\t"*l}<#{k}>#{v}</#{k}>\n"
        end
      end
      xml
    end
    
  end
end