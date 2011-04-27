require 'logger'
module IPay
  class Log < Logger
    def format_message(severity, timestamp, progname, msg)
      "#{timestamp} #{severity} -- #{msg}\n" 
    end
  end
  
  def self.log_file
    path = File.join(ROOT, 'log')
    path = '.' unless File.directory?(path)
    File.expand_path(File.join(path, LOG_NAME))
  end
  
  def self.init_log(log = nil)
    @log = Log.new(log||log_file)
    @log.level = Logger::WARN if ENV == 'production'
    @log
  end
  
  def self.log
    @log ||= init_log
  end
  
  def self.log=(log)
    init_log log
  end
end