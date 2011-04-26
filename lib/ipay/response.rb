require 'xml'

module IPay
  class Response

    STATUS_REGEX = {
      :success => '0([0-9]{3})',
      :error => '1([0-9])([0-9]{2})',
      :fatal => '2([0-9]{3})'
    }

    attr_reader :status, :data, :raw_xml
    
    def initialize(xml)
      if IPay::config.dry_run
        @status = {:code => '0000', :description => 'Dry Run, no response processed'}
      else
        @raw_xml = xml
        parse_response @raw_xml
      end
    end
    
    def success?
      @status[:code].match(STATUS_REGEX[:success]) != nil
    end
    
    def warning?
      m = @status[:code].match(STATUS_REGEX[:success])
      m && m[1].to_i > 0
    end
    
    def error?
      @status[:code].match(STATUS_REGEX[:error]) != nil
    end
    
    def fatal?
      @status[:code].match(STATUS_REGEX[:fatal]) != nil
    end
    
    private
    
    def parse_response(xml)
      IPay::log.debug 'Parsing response xml...'
      parser = XML::Parser.string xml
      parser.context.options = XML::Parser::Options::NOBLANKS | XML::Parser::Options::NOERROR |
                               XML::Parser::Options::RECOVER | XML::Parser::Options::NOWARNING
      
      response = xml_node_to_hash(parser.parse.find('//Response')[0])
      raise ResponseError.new 'Invalid response from server' unless response and response.include? :status
      IPay::log.info "Response status: #{response[:status][:description]} (#{response[:status][:code]})"
      IPay::log.debug response
      
      @status = response[:status]
      @data   = response[:data].values[0] if response.has_key? :data
    end
    
    def xml_node_to_hash(node)
      result = {}
      if node.element? && node.children? && node.children[0].element?
        node.children.each do |child|
          sym_name = child.name.downcase.sub('response_', '').to_sym
          if result.include? sym_name
            result[sym_name] = [result[sym_name]] unless result[sym_name].is_a? Array
            result[sym_name].push xml_node_to_hash(child)
          else
            result[sym_name] = xml_node_to_hash(child)
          end
        end
        result
      else
        node.content.strip
      end
    end
    
  end
end