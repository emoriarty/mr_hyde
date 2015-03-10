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
      def create(args, opts = {})
        opts = MrHyde.configuration(opts)

        if args.kind_of? Array and not args.empty?
          args.each do |bn| 
            begin
              create_blog(bn, opts)
            rescue Exception => e
              raise e unless e.class == SystemExit
            end
          end
        elsif args.kind_of? String
          create_blog args, opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot create blog: #{e}"
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def remove(args, opts = {})
        opts = MrHyde.configuration(opts)

        if args.kind_of? Array
          args.each do |sm|
            remove_blog sm, opts
          end
        else
          remove_blog args, opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot remove the blog: #{e}"
      end

      # Builds the blog
      # Params:
      #   :name
      #     String => builds the concrete blog
      #     Array[String] => builds the correspondings blog names
      #     empty => It builds all blogs
      # Returns
      #   boolean
      def build(args, opts = {})
        args = [args] if args.kind_of? String
        opts = MrHyde.configuration(opts)

        if opts["all"]
          build_blogs list(opts['sources']), opts
        elsif args.kind_of? Array
          build_blogs args, opts 
        elsif args.kind_of? String
          build_blog args
        end
      rescue Exception => e
        MrHyde.logger.error "cannot build site: #{e}"
        MrHyde.logger.error e.backtrace
      end

      def list(path)
        entries = Dir.entries(path)
        entries.reject! { |item| item == '.' or item == '..' }
        entries
      end

      def exist?(name, opts)
        File.exist? File.join(opts['sources'], name)
      end
        
      def built?(name, opts)
        File.exist? File.join(opts['destination'], name)
      end

      private

      def create_blog(args, opts = {})
        Jekyll::Commands::New.process [File.join(opts['sources'], args)], opts
        exist? args, opts
      end

      def remove_blog(name, opts = {})
        if File.exist? File.join(opts['sources'], name)
          FileUtils.remove_dir File.join(opts['sources'], name)
          MrHyde.logger.info "#{name} removed from #{opts['sources']}"
        end
        if File.exist? File.join(opts['destination'], name)
          FileUtils.remove_dir File.join(opts['destination'], name)
          MrHyde.logger.info "#{name} removed from #{opts['destination']}"
        end
      end

      def build_blogs(site_names, opts)
        site_names.each do |sn| 
          begin
            build_blog(sn, opts)
          rescue Exception => e
            MrHyde.logger.error e
          end
        end
      end

      def build_blog(name, opts)
        Jekyll::Commands::Build.process 'source' => File.join(opts['sources'], name), 
          'destination' => File.join(opts['destination'], name)
        built? name, opts
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
