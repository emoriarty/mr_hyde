require "jekyll"
require "fileutils"
require "mr_hyde"
require "mr_hyde/configuration"

# TODO: The site place must be taken from the default config or the one provided by user
module MrHyde
  class Blog
    
    class << self
      # Creates the directory and necessary files for the blog
      # Options
      #   :name
      #     String => creates the concrete blog
      #     Array[String] => creates the correspondings blog names
      # Returns
      #   boolean
      def create(opts)
        return false unless site?
        return false if opts[:name].nil? or opts[:name].empty?

        if opts[:name].kind_of? Array
          opts.delete(:name).each { |bn| create_blog(opts.merge({ :name => bn  })) }
        elsif opts[:name].kind_of? String
          create_blog opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot create blog: #{e}"
        false
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def remove(opts)
        return false if not check_blog(opts[:name], :exist?, "#{opts[:name]} cannot be removed, blog does not exist")

        FileUtils.remove_dir File.join(MrHyde.configuration.sources, opts[:name])
        MrHyde.logger.debug "#{opts[:name]} blog removed properly from the root path#{MrHyde.configuration.root}"
        not exist? opts[:name]
      rescue Exception => e
        MrHyde.logger.error "cannot remove the blog: #{e}"
        false
      end

      # Builds the blog
      # Params:
      #   :name
      #     String => builds the concrete blog
      #     Array[String] => builds the correspondings blog names
      #     empty => It builds all blogs
      # Returns
      #   boolean
      def build(opts = {})
        if opts[:name].kind_of? Array
          opts.delete(:name).each { |bn| build_blog opts.merge({ :name => bn }) }
        elsif opts[:name].kind_of? String
          build_blog opts
        elsif opts[:name].nil?
          list.each { |bn| build_blog opts.merge({ :name => bn }) }
        end
      rescue Exception => e
        MrHyde.logger.error "cannot build site: #{opts[:name]}: #{e}"
        false
      end

      def list
        entries = Dir.entries MrHyde.configuration.sources
        entries.reject! { |item| item == '.' or item == '..' }
        entries
      end

      def exist?(blog_name)
        File.exist? File.join(MrHyde.configuration.sources, blog_name)
      end
        
      def built?(blog_name)
        File.exist? File.join(MrHyde.configuration.destination, blog_name)
      end

      private

      def create_blog(opts)
        return false if check_blog(opts[:name], :exist?, "#{opts[:name]} blog already exist")

        Jekyll::Commands::New.process [File.join(MrHyde.configuration.sources, opts[:name])]
        exist? opts[:name] 
      end

      def build_blog(opts)
        return false if check_blog(opts[:name], :built?, "#{opts[:name]} cannot be built, blog already built")

        Jekyll::Commands::Build.process 'source' => File.join(MrHyde.configuration.sources, opts[:name]), 'destination' => File.join(MrHyde.configuration.destination, opts[:name])
        built? opts[:name]
      end

      def site?
        File.exist? MrHyde.configuration.root
      end

      def check_blog(blog_name, method, message)
        if not send(method, blog_name)
          MrHyde.logger.debug message
          return false
        end
        true
      end

    end

  end
end
