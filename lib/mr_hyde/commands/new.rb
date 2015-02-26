require "fileutils"

require "mr_hyde/configuration"
require "mr_hyde/jekyll/new"
require "mr_hyde/command"

module MrHyde
  module Commands
    class New < MrHyde::Command
      class << self
        def process
          FileUtils.mkdir_p(configuration.sources) unless File.exist?(configuration.sources)
          FileUtils.mkdir_p(configuration.destination) unless File.exist?(configuration.destination)
          FileUtils.copy_file MrHyde::Jekyll::New.default_config_file, 
            File.join(configuration.root, configuration.file)
        end
      end
    end
  end
end
