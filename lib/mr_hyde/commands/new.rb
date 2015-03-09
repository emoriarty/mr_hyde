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
            when :site then new_site(args[:args], opts)
            else scaffold(args, opts)
          end
        end
        
        private 

          def scaffold(args, opts)
            new_site_path = MrHyde.create args, opts
            MrHyde.logger.info "New Mr. Hyde Site installed in #{new_site_path}"
          rescue SystemExit => se
            MrHyde.logger.abort_with "Conflict:", se.message
          end

          def new_site(args, opts)
            Blog.create(args, opts)
          end
      end
    end
  end
end
