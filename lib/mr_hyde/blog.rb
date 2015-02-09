require "jekyll"
require "fileutils"
require "logger"

# TODO: The site place must be taken from the default config or the one provided by user
module MrHyde
  class Blog
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    
    class << self
      # Creates the directory and necessary files for the blog
      #
      def create(args)
        Jekyll::Commands::New.process args[:path]
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      #
      def remove(args)
        FileUtils.remove_dir args[:path]
        @logger.info "#{args[:path]} blog removed properly"
      rescue
        @logger.error "cannot remove the blog"
      end
    end

  end
end
