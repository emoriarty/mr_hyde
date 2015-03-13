require "jekyll"
require "fileutils"
require "mr_hyde"
require "mr_hyde/configuration"

# TODO: The site place must be taken from the default config or the one provided by user
module MrHyde
  class Blog
    class << self
      def init(args, opts)
        opts = MrHyde.configuration(opts)
        @source = if opts['main']
                    File.join MrHyde.source, MrHyde.sources
                  else
                    File.join MrHyde.source, MrHyde.sources_sites
                  end
        puts "Blog source: #{@source}\n"
        yield if block_given?
      end

      # Creates the directory and necessary files for the blog
      # args
      #   :name
      #     String => creates the concrete blog
      #     Array[String] => creates the correspondings blog names
      # Returns
      #   boolean
      def create(args, opts = {})
        init(args, opts)

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
        MrHyde.logger.error e.backtrace
      end

      # Removes the blog directory
      # Params:
      #   Hash[:path] (String)
      # Returns
      #   boolean
      def remove(args, opts = {})
        init(args, opts)

        unless is_main?
          if opts['all']
            list(MrHyde.sources_sites).each do |sm|
              remove_blog sm, opts
            end
          elsif args.kind_of? Array
            args.each do |sm|
              remove_blog sm, opts
            end
          else
            remove_blog args, opts
          end
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
        init(args, opts)

        unless opts.delete('main')
          if opts["all"]
            build_blogs list(MrHyde.sources_sites), opts
          elsif args.kind_of? Array
            build_blogs args, opts 
          elsif args.kind_of? String
            build_blog args, opts
          end
        else
          build_main_site(opts)
          #if opts["full"]
            build_blogs list(MrHyde.sources_sites), opts
          #end
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
        File.exist? File.join(MrHyde.sources_sites, name)
      end
        
      def built?(name, opts)
        File.exist? File.join(MrHyde.destination, name)
      end

      def has_custom_config?(name, opts)
        File.exist? custom_config(name, opts)
      end

      def site_path(name)
        Jekyll.sanitized_path @source, name
      end
      
      def custom_config(name, opts)
        File.join site_path(name), opts['jekyll_config']
      end
      
      def is_main?(name)
        File.directory? File.join(@source, name)
      end

      private

      def create_blog(args, opts = {})
        begin
          if args.kind_of? Array
            args.each do |name|
              raise() if is_main(args)
            end
          else
            raise() if is_main?(args)
          end
        rescue Exception => e
          raise ArgumentError, 'The site\'s name cannot be the same than the main site name'
        end

        MrHyde::Extensions::New.process [File.join(MrHyde.sources_sites, args)], opts
        exist? args, opts
      end

      def remove_blog(name, opts = {})
        if opts['full'] and File.exist? File.join(MrHyde.sources_sites, name)
          FileUtils.remove_dir File.join(MrHyde.sources_sites, name)
          MrHyde.logger.info "#{name} removed from #{MrHyde.sources_sites}"
        end
        if File.exist? File.join(MrHyde.destination, name)
          FileUtils.remove_dir File.join(MrHyde.destination, name)
          MrHyde.logger.info "#{name} removed from #{MrHyde.destination}"
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
        conf = MrHyde.custom_configuration(name)
        puts conf
        Jekyll::Commands::Build.process conf
        built? name, opts
      end

      def build_main_site(opts)
        conf = MrHyde.custom_main_configuration(opts)
        puts conf
        Jekyll::Commands::Build.process conf
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
