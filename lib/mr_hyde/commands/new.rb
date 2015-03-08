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
        def process(args, opts = {})
          case args.delete(:type)
            when :blog then new_blog(args[:args], opts)
            when :site then new_site(args[:args], opts)
          end
        end
        
        private 
          def preserve_source_location?(path, opts)
            !opts["force"] && !Dir["#{path}/**/*"].empty?
          end

          def new_site(args, opts)
            new_site_path = File.expand_path(args.join(" "), Dir.pwd)
            FileUtils.mkdir_p new_site_path
            if preserve_source_location?(new_site_path, opts)
              MrHyde.logger.abort_with "Conflict:", "#{new_site_path} exists and is not empty."
            end

            create_sample_files new_site_path

            MrHyde.logger.info "New Mr. Hyde Site installed in #{new_site_path}"
          end

          def new_blog(args, opts)
            Blog.create({ :name => args }, opts)
          end

          def create_sample_files(path)
            FileUtils.cp_r site_template + '/.', path
            FileUtils.copy_file MrHyde::Extensions::New.default_config_file, 
              File.join(path, '_jekyll.yml')
          end

          def site_template
            File.expand_path("../../site_template", File.dirname(__FILE__))
          end
      end
    end
  end
end
