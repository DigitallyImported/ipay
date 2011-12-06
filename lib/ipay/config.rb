require 'yaml'
require 'ostruct'

module IPay
  ServiceDefaults = { 
    :currency_code => Country['US'].number,
    :currency_indicator => CUR_INDICATOR_DOMESTIC,
    :transaction_indicator => TXN_INDICATOR_HTTPS
  }
  
  class << self
    
    def default_log_file
      path = File.join(ROOT, 'log')
      path = '.' unless File.directory?(path)
      File.expand_path(File.join(path, "#{LOG_PREFIX}-#{ENV}.log"))
    end
    
    def config_file
      File.expand_path(File.join(ROOT, 'config', CONFIG_NAME))
    end
  
    def load_config_file(file = nil)
      raise "Cannot load configuration file '#{file}'" if file and !File.readable?(file)
      
      file ||= config_file
      begin
        config = OpenStruct.new(YAML.load_file(file)[ENV])
      rescue Errno::ENOENT
        config = OpenStruct.new
      end
      
      set_defaults(config)
    end
    
    def set_defaults(config)
      config.dry_run ||= false
      config.certification ||= false
      config.retries ||= 3
      config.log_file ||= default_log_file
      config.defaults = ServiceDefaults.merge config.defaults || {}
      config
    end

    def config(file = nil)
      @config ||= load_config_file(file)
      yield @config if block_given?
      @config
    end
  end
end