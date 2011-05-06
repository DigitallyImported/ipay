module IPay
  module Util
    
    ESCAPE_CHARS = { '&' => '&amp;', '"' => '&quot;', '<' => '&lt;', '>' => '&gt;', "'" => '&apos;' }
    
    def self.escape(string)
      string.to_s.gsub(Regexp.new(ESCAPE_CHARS.keys.join('|')), ESCAPE_CHARS)
    end
    
    def self.unescape(string)
      string.gsub(Regexp.new(ESCAPE_CHARS.values.join('|')), ESCAPE_CHARS.invert)
    end
    
    def self.hash_to_xml(h, l=0)
      return h.to_s unless h.is_a? Hash
      xml = ''
      h.each do |k,v|
        k = k.to_s.upcase
        xml << if v.kind_of? Enumerable
          (v.is_a?(Array) ? v : Array[v]).collect { |group| "#{"\t"*l}<#{k}>\n#{hash_to_xml(group, l+1)}#{"\t"*l}</#{k}>\n"}.join
        else
          "#{"\t"*l}<#{k}>#{self.escape(v)}</#{k}>\n"
        end
      end
      xml
    end
    
  end
end