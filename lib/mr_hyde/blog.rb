require "jekyll"
require "fileutils"
require "mr_hyde"
require "mr_hyde/configuration"

# TODO: The site place must be taken from the default config or the one provided by user
module MrHyde
  class Blog
    
    class << self
      # Creates the directory and necessary files for the blog
      # args
      #   :name
      #     String => creates the concrete blog
      #     Array[String] => creates the correspondings blog names
      # Returns
      #   boolean
      def create(args, opts)
        return false if args[:name].nil? or args[:name].empty?

        if args[:name].kind_of? Array and not args[:name].empty?
          args.delete(:name).each do |bn|
            create_blog(args.merge({ :name => bn  }), opts)
          end
        elsif args[:name].kind_of? String
          create_blog args, opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot create blog: #{e}"
        MrHyde.logger.debug e.backtrace
        false
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def remove(args, opts = {})

        if args.kind_of? Array
          args.each do |sm|
            remove_blog sm, opts
          end
        else
          remove_blog args, opts
        end
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
      def build(args = {})
        if args[:name].kind_of? Array
          args.delete(:name).each { |bn| build_blog args.merge({ :name => bn }) }
        elsif args[:name].kind_of? String
          build_blog args
        elsif args[:name].nil?
          list.each { |bn| build_blog args.merge({ :name => bn }) }
        end
      rescue Exception => e
        MrHyde.logger.error "cannot build site: #{args[:name]}: #{e}"
        false
      end

      def list
        entries = Dir.entries MrHyde.configuration.sources
        entries.reject! { |item| item == '.' or item == '..' }
        entries
      end

      def exist?(path, blog_name)
        File.exist? File.join(path, blog_name)
      end
        
      def built?(blog_name)
        File.exist? File.join(MrHyde.configuration.destination, blog_name)
      end

      private

      def create_blog(args, opts = Hash.new)
        options = MrHyde.configuration(opts)
        Jekyll::Commands::New.process [File.join(options['sources'], args[:name])], opts
        exist? options['sources'], args[:name] 
      end

      def remove_blog(name, opts = {})
        options = MrHyde.configuration(opts)
        if File.exist? File.join(options['sources'], name)
          FileUtils.remove_dir File.join(options['sources'], name)
        end
        if File.exist? File.join(options['destination'], name)
          FileUtils.remove_dir File.join(options['destination'], name)
        end
        MrHyde.logger.info "#{name} site removed"
      end

      def build_blog(args)
        return false if check_blog(args[:name], :built?, "#{args[:name]} cannot be built, blog already built")

        Jekyll::Commands::Build.process 'source' => File.join(MrHyde.configuration.sources, args[:name]), 'destination' => File.join(MrHyde.configuration.destination, args[:name])
        built? args[:name]
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
