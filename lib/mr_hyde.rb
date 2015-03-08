require "mr_hyde/version"
require "mr_hyde/configuration"
require "mr_hyde/commands/new"
require "mr_hyde/commands/build"

require "logger"

require "jekyll/stevenson"
require "jekyll/log_adapter"
require "jekyll/utils"

module MrHyde
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def configuration(override = Hash.new)
      config = Configuration[Configuration::DEFAULTS]
      override = Configuration[override].stringify_keys
      unless override.delete('skip_config_files')
        override['config'] ||= config['config']
        config = config.read_config_files(config.config_files(override))
      end
      # Merge DEFAULTS < _config.yml < override
      config = Jekyll::Utils.deep_merge_hashes(config, override).stringify_keys
      set_timezone(config['timezone']) if config['timezone']
      
      config
    end

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    def logger
      Jekyll.logger
    end

    # Creates the folders for the sources and destination, 
    # by default will be created under root folder.
    # Copies the default _config.yml for all blogs, in root folder.
    #
    def create(action = nil, opts = {})
      opts[:type] = action
      Commands::New.process opts    
    end

    def build(opts = {})
      Commands::Build.process opts
    end
  end

end
