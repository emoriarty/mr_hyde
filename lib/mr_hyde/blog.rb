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
      #   :name => blog's name
      # Returns
      #   boolean
      def create(args)
        return false if check_blog(args[:name], :exist?, "#{args[:name]} blog already exist")

        Jekyll::Commands::New.process [File.join(MrHyde.configuration.source_path, args[:name])]
        exist? args[:name] 
      rescue Exception => e
        @logger.error "cannot create blog: #{e}"
        false
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def remove(args)
        return false if not check_blog(args[:name], :exist?, "#{args[:name]} cannot be removed, blog does not exist")

        FileUtils.remove_dir File.join(MrHyde.configuration.source_path, args[:name])
        @logger.debug "#{args[:name]} blog removed properly from the root path#{MrHyde.configuration.root_path}"
        not exist? args[:name]
      rescue Exception => e
        @logger.error "cannot remove the blog: #{e}"
        false
      end

      # Builds the blog
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def build(args)
        return false if check_blog(args[:name], :built?, "#{args[:name]} cannot be built, blog already built")

        Jekyll::Commands::Build.process 'source': File.join(MrHyde.configuration.source_path, args[:name]), 
          'destination': File.join(MrHyde.configuration.destination_path, args[:name])
        built? args[:name]
      rescue Exception => e
        @logger.error "cannot build site: #{args[:name]}: #{e}"
        false
      end

      def exist?(blog_name)
        File.exist? File.join(MrHyde.configuration.source_path, blog_name)
      end
        
      def built?(blog_name)
        File.exist? File.join(MrHyde.configuration.destination_path, blog_name)
      end

      private

      def check_blog(blog_name, method, message)
        if not send(method, blog_name)
          @logger.debug message
          return false
        end
        true
      end

    end

  end
end
