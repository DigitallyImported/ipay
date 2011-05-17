require 'yaml'
require 'ostruct'

module IPay
  
  DEFAULTS = { 
    :currency_code => IPay::Countries[:us][:currency_code], 
    :currency_indicator => CUR_INDICATOR_DOMESTIC,
    :transaction_indicator => TXN_INDICATOR_HTTPS
  }
  
  def self.config_file
    File.expand_path(File.join(ROOT, 'config', CONFIG_NAME))
  end

  def self.load_config_file
    path = File.expand_path(config_file)
    
    if File.readable?(path)
      IPay::log.debug "Using configuration file '#{path}'"
      config = OpenStruct.new(YAML.load_file(path)) unless config
    else
      config = OpenStruct.new
    end
    
    set_defaults(config)
  end

  def self.set_defaults(config)
    config.dry_run ||= false
    config.certification ||= false
    config.defaults = DEFAULTS.merge(config.defaults || {}) # yaml config has higher priority
    config
  end

  def self.config
    @config ||= load_config_file
    yield @config if block_given?
    @config
  end
end