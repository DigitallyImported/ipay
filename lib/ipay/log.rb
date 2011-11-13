require 'logger'
module IPay
  
  class Log < Logger
    def format_message(severity, timestamp, progname, msg)
      "#{timestamp} #{severity} -- #{msg}\n" 
    end
  end
  
  class HttpDebug
    def initialize
      @buffer = ''
    end
    
    def <<(msg)
      @buffer << msg
      if @buffer.match "\n"
        IPay.log.debug "Net::HTTP -- #{format_msg(@buffer)}"
        @buffer = ''
      end
    end
    
    private
    def format_msg(msg)
      msg.gsub("\n", '').sub /^->|<-/, {'->' => 'RECV:', '<-' => 'SENT:'}
    end
  end
  
  class << self
    def init_log(log = nil)
      @log = 
      if log and log.is_a? Logger
        log
      else
        Log.new log || IPay.config.log_file
      end
      
      @log.level = Logger::WARN if ENV == 'production'
      @log
    end
    
    def log
      @log ||= init_log
    end
  
    def log=(log)
      init_log log
    end
  end
end