require "fileutils"

require "mr_hyde"
require "mr_hyde/configuration"
require "mr_hyde/extensions/new"
require "mr_hyde/command"

module MrHyde
  module Commands
    class New < MrHyde::Command
      class << self
        def process
          if preserve_source_location?(MrHyde.configuration.root)
            MrHyde.logger.abort_with "Conflict:", "#{MrHyde.configuration.root} exists and is not empty."
          end

          FileUtils.mkdir_p(configuration.sources) unless File.exist?(configuration.sources)
          FileUtils.mkdir_p(configuration.destination) unless File.exist?(configuration.destination)
          FileUtils.copy_file mrhyde_config_template, 
            File.join(configuration.root, configuration.config_file)
          FileUtils.copy_file MrHyde::Extensions::New.default_config_file, 
            File.join(configuration.root, configuration.jekyll_config_file)
        end
        
        def preserve_source_location?(path, options=nil)
          #!options["force"] && !Dir["#{path}/**/*"].empty?
          !Dir["#{path}/**/*"].empty?
        end

        def templates_path
          File.expand_path "../../templates", File.dirname(__FILE__)
        end

        def mrhyde_config_template
          File.join templates_path, '_mrhyde.yml'
        end
      end
    end
  end
end
