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
      # Options
      #
      def create(args)
        Jekyll::Commands::New.process [File.join(MrHyde.configuration.source_path, args[:name])]
      rescue
        @logger.error "cannot create blog"
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      #
      def remove(args)
        FileUtils.remove_dir File.join(MrHyde.configuration.source_path, args[:name])
        @logger.debug "#{args[:name]} blog removed properly from the root path#{MrHyde.configuration.root_path}"
      rescue
        @logger.error "cannot remove the blog"
      end

      def build(args)
        Jekyll::Commands::Build.process 'source': File.join(MrHyde.configuration.source_path, args[:name]), 
          'destination': File.join(MrHyde.configuration.destination_path, args[:name])
      rescue
        @logger.error "cannot build site: #{args[:name]}"
      end

      def exist?(blog_name)
        File.exist? File.join(MrHyde.configuration.source_path, blog_name)
      end
        
      def built?(blog_name)
        File.exist? File.join(MrHyde.configuration.destination_path, blog_name)
      end
    end

  end
end
