require "mr_hyde/version"
require "mr_hyde/configuration"
require "mr_hyde/commands/new"

require "logger"

require "jekyll/stevenson"
require "jekyll/log_adapter"

module MrHyde
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
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
    def create
      Commands::New.process
    end
  end

end
