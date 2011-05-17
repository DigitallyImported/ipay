require 'xml'
require 'date'
require 'ipay/util'

module IPay
  class Response
    
    PARSER_OPT = XML::Parser::Options::NOBLANKS | XML::Parser::Options::NOERROR | XML::Parser::Options::RECOVER | XML::Parser::Options::NOWARNING
    
    attr_reader :status, :server_time, :data, :raw_xml
  
    def initialize(xml)
      if IPay::config.dry_run
        @status = {:arc => '00', :mrc => '00', :description => 'Dry Run, no response processed'}
      else
        @raw_xml = xml
        parse_response @raw_xml
      end
    end
  
    def success?
      @status[:arc] == '00' && @status[:mrc] == '00'
    end
  
    def error?
      not success?
    end
  
    private
    
    def parse_response(xml)
      IPay.log.debug 'Parsing response xml...'
      IPay.log.debug xml
      
      parser = XML::Parser.string xml
      parser.context.options = PARSER_OPT
      parsed = parser.parse
    
      IPay::Certification.log(parsed) if IPay::config.certification
    
      response = xml_node_to_hash(parsed.find('//RESPONSE/RESPONSE/FIELDS')[0])
      raise ResponseError.new 'Invalid response from server' unless response and response.include? :arc
      
      if response.include?(:local_date)
        d = response.delete(:local_date).match(/([0-9]{2})([0-9]{2})([0-9]{4})/)
        t = response.delete(:local_time).match(/([0-9]{2})([0-9]{2})([0-9]{2})/)
      end
      
      @server_time = DateTime.parse("#{d[3]}-#{d[1]}-#{d[2]}T#{t[1]}:#{t[2]}:#{t[3]}") rescue DateTime.now
      @status = { :arc => response.delete(:arc), :mrc => response.delete(:mrc), :description => response.delete(:response_text) }
      @data = response
    
      IPay::log.info "ARC=#{@status[:arc]}, MRC=#{@status[:mrc]}, RESPONSE_TEXT=#{@status[:description]}"
      IPay::log.debug response
      raise RequestTimeout.new(@status[:description]) if @status[:arc] == 'TO'
    end
  
    def xml_node_to_hash(node)
      result = {}
      if node.element? && node.children? && node.children[0].element?
        node.children.each do |child|
          result[child.name.downcase.to_sym] = xml_node_to_hash(child)
        end
        result
      else
        Util.unescape(node.content.strip)
      end
    end
  
  end
end