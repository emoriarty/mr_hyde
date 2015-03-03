require "fileutils"

require "jekyll"

require "mr_hyde"
require "mr_hyde/configuration"
require "mr_hyde/extensions/new"
require "mr_hyde/command"
require "mr_hyde/blog"

module MrHyde
  module Commands
    class New < MrHyde::Command
      class << self
        # Options
        #  :type => what type of element we want to create [:blog|:site]
        #     by default it creates a new MrHyde site
        # if :type is :blog then
        #   :name => blog's name
        #
        def process(opts)
          case opts.delete(:type)
            when :blog
              new_blog opts
            when :site
            else
              new_site
          end
        end
        
        def preserve_source_location?(path, opts=nil)
          #!options["force"] && !Dir["#{path}/**/*"].empty?
          !Dir["#{path}/**/*"].empty?
        end

        def templates_path
          File.expand_path "../../templates", File.dirname(__FILE__)
        end

        def mrhyde_config_template
          File.join templates_path, '_mrhyde.yml'
        end
        private 
          def new_site
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

          def new_blog(opts)
            MrHyde::Blog.create(opts)
          end
      end
    end
  end
end
