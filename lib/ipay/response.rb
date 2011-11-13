require 'xml'
require 'date'
require 'ipay/util'

module IPay
  class Response
    
    PARSER_OPT = XML::Parser::Options::NOBLANKS | XML::Parser::Options::NOERROR | XML::Parser::Options::RECOVER | XML::Parser::Options::NOWARNING
    
    attr_reader :status, :server_time, :data, :raw_xml
  
    def initialize(xml)
      if IPay.config.dry_run
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
  
    def errors
      @errors ||= []
    end
  
    protected
    
    def parse_response(xml)
      IPay.log.debug 'Parsing response xml...'
      IPay.log.debug xml
      
      parser = XML::Parser.string xml
      parser.context.options = PARSER_OPT
      parsed = parser.parse
    
      Certification.log(parsed) if IPay.config.certification
    
      response = xml_node_to_hash(parsed.find('//RESPONSE/RESPONSE/FIELDS')[0])
      raise ResponseError.new 'Invalid response from server' unless response and response.include? :arc
      
      if response.include?(:local_date)
        d = response.delete(:local_date).match(/([0-9]{2})([0-9]{2})([0-9]{4})/)
        t = response.delete(:local_time).match(/([0-9]{2})([0-9]{2})([0-9]{2})/)
      end
      
      @server_time = DateTime.parse("#{d[3]}-#{d[1]}-#{d[2]}T#{t[1]}:#{t[2]}:#{t[3]}") rescue DateTime.now
      @status = { :arc => response.delete(:arc), :mrc => response.delete(:mrc), :description => response.delete(:response_text) }
      @data = response
    
      IPay.log.info "ARC=#{@status[:arc]}, MRC=#{@status[:mrc]}, RESPONSE_TEXT=#{@status[:description]}"
      IPay.log.debug response
      
      process_errors(@status[:mrc], @status[:arc], @status[:description]) unless success?
    end
  
    def process_errors(mrc, arc, desc)
      
      unless arc == 'ER' # denotes MRC error
        errors << 
        case(arc)
          when 'TO' then raise RequestTimeout.new desc
          #when '59' then raise FraudError.new
          #when '79' then 'Already reversed'
          #else "Transaction declined: mrc=#{mrc}, arc=#{arc}, description=#{desc}"
        end
      end
      
      errors <<
      case(mrc)
        when 'UP' then raise ServiceUnavailableError.new('System unavailable, retry')
        when 'SU' then raise ServiceUnavailableError.new('Unable to process at this time, retry')
        when 'IC' then raise RequestError.new('Missing or invalid Company Key')
        when 'ID' then raise RequestError.new('Missing or invalid Transaction data')
        when 'NX' then raise RequestError.new('Invalid Request: FIELDS node not present')
        
        # when 'AE' then 'Authorization has expired'
        #         when 'AX' then "Transaction amount exceeded: #{desc}"
        #         when 'CF' then 'Credit refused, no relevant sale'
        #         when 'DR' then 'Unable to delete'
        #         when 'IK' then "Invalid Key: #{desc}"
        #         when 'MK' then "Missing Key: #{desc}"
        #         when 'TF' then 'Transaction not found'
        #         when 'TS' then 'Transaction not settled'
        #         when 'TC' then 'Transaction already captured'
        #         when 'TD' then 'Transaction already deleted'
        #         when 'TR' then 'Transaction already reversed'
        #         when 'TS' then 'Transaction already settled'
        #         when 'TV' then 'Transaction already deleted'
        #         when 'VR' then 'Void Refused'
        #         when 'XE' then 'Currencery conversion error'
        #         else "Error processing transaction: mrc=#{mrc}, arc=#{arc}, description=#{desc}"
      end
      
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