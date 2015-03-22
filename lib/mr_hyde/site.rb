require "jekyll"
require "fileutils"
require "mr_hyde"
require "mr_hyde/configuration"

module MrHyde
  class Site
    class << self
      def init(args, opts)
        opts = MrHyde.configuration(opts)
        @source = if opts['main']
                    File.join MrHyde.source, MrHyde.sources
                  else
                    File.join MrHyde.source, MrHyde.sources_sites
                  end
        yield if block_given?
      end

      # Creates the directory and necessary files for the site
      # Params:
      #   args
      #     String => creates the concrete site
      #     Array[String] => creates the correspondings site names
      #   opts
      #     Hash 
      #       'force' => 'force' Install the new site over an exiting path
      #       'blank' => 'blank' Creates a blank site
      #
      def create(args, opts = {})
        init(args, opts)

        if args.kind_of? Array and not args.empty?
          args.each do |bn| 
            begin
              create_site(bn, opts)
            rescue Exception => e
              raise e unless e.class == SystemExit
            end
          end
        elsif args.kind_of? String
          create_site args, opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot create site: #{e}"
      end

      # Removes the site directory
      # Params:
      #   args
      #     String => removes the concrete site
      #     Array[String] => removes the correspondings site names
      #     empty => remove all sites with the option 'all'
      #   opts
      #     Hash 
      #       'all' => 'all' Removes all built sites
      #       'full' => 'full' Removes built and source site/s
      #
      def remove(args, opts = {})
        init(args, opts)

        if opts['all']
          list(MrHyde.sources_sites).each do |sm|
            remove_site sm, opts
          end
        elsif args.kind_of? Array
          args.each do |sm|
            remove_site sm, opts
          end
        else
          remove_site args, opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot remove the site: #{e}"
      end

      # Builds the site
      # Params:
      #   :name
      #     String => builds the concrete site
      #     Array[String] => builds the correspondings site names
      #     empty => builds all sites with option 'all'
      #   opts
      #     Hash 
      #       'all' => 'all' Builds all built sites
      #
      def build(args, opts = {})
        init(args, opts)

        unless opts.delete('main')
          # If there is no main sitem then it is built
          build_main_site(opts) unless File.exist? MrHyde.destination

          if opts["all"]
            build_sites list(MrHyde.sources_sites), opts
          elsif args.kind_of? Array
            build_sites args, opts 
          elsif args.kind_of? String
            build_site args, opts
          end
        else
          build_main_site(opts)
          build_sites list(MrHyde.sources_sites), opts
        end
      rescue Exception => e
        MrHyde.logger.error "cannot build site: #{e}"
      end

      # This method returns a list of nested sites
      #
      def list(path)
        entries = Dir.entries(path)
        entries.reject! { |item| item == '.' or item == '..' }
        entries
      end

      def exist?(name, opts)
        File.exist? File.join(@source, name)
      end
        
      def built?(name, opts)
        File.exist? File.join(MrHyde.destination, name)
      end

      def has_custom_config?(name, opts)
        File.exist? custom_config(name, opts)
      end

      def site_path(name)
        source = is_main?(name) ? @source : File.join(MrHyde.source, MrHyde.sources_sites)
        Jekyll.sanitized_path(source , name)
      end
      
      def custom_config(name, opts)
        File.join site_path(name), opts['jekyll_config']
      end
      
      def is_main?(name)
        File.directory? File.join(MrHyde.sources, name)
      end

      private

      def create_site(args, opts = {})
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
        MrHyde.logger.info "New #{args} created in #{MrHyde.sources_sites}"
        exist? args, opts
      end

      def remove_site(name, opts = {})
        # OBSOLOTE
        # This checking is not mandatory, never can be removed form here the main site
        if is_main?(name)
          MrHyde.logger.warning "Cannot remove main site: #{name}"
          return
        end

        if opts['full'] and File.exist? File.join(MrHyde.sources_sites, name)
          FileUtils.remove_dir File.join(MrHyde.sources_sites, name)
          MrHyde.logger.info "#{name} removed from #{MrHyde.sources_sites}"
        end
        if File.exist? File.join(MrHyde.destination, name)
          FileUtils.remove_dir File.join(MrHyde.destination, name)
          MrHyde.logger.info "#{name} removed from #{MrHyde.destination}"
        end
      end

      def build_sites(site_names, opts)
        site_names.each do |sn| 
          begin
            build_site(sn, opts)
          rescue Exception => e
            MrHyde.logger.error e
          end
        end
      end

      def build_site(name, opts)
        conf = MrHyde.site_configuration(name)
        Jekyll::Commands::Build.process conf
        MrHyde.logger.info "#{name} built in #{MrHyde.destination}"
        built? name, opts
      end

      def build_main_site(opts)
        conf = MrHyde.main_site_configuration
        Jekyll::Commands::Build.process conf
      end


      def check_site(site_name, method, message)
        if not send(method, site_name)
          MrHyde.logger.debug message
          return false
        end
        true
      end

    end

  end
end
