require "mr_hyde/version"
require "mr_hyde/configuration"
require "mr_hyde/commands/new"

module MrHyde
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      self.configuration
    end

    # Creates the folders for the sources and destination, 
    # by default will be created under root folder.
    # Copies the default _config.yml for all blogs go the same root folder.
    #
    def create
      Commands::New.process
    end
  end

end
