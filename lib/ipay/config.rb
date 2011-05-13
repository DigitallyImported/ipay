require 'yaml'
require 'ostruct'

module IPay
  
  def self.config_file
    File.expand_path(File.join(ROOT, 'config', CONFIG_NAME))
  end

  def self.load_config_file
    path = File.expand_path(config_file)
    
    if File.readable?(path)
      IPay::log.debug "Using configuration file '#{path}'"
      @config = OpenStruct.new(YAML.load_file(path)) unless @config
    else
      @config = OpenStruct.new
      IPay::log.warn "Failed to locate configuration file '#{CONFIG_NAME}', place in 'config/'"
    end
    
    set_defaults(@config)
  end

  def self.set_defaults(config)
    config.dry_run ||= false
    config.certification ||= false
    config
  end

  def self.config
    @config ||= load_config_file
    yield @config if block_given?
    @config
  end
end