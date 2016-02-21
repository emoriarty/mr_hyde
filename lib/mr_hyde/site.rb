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
                    File.join MrHyde.source
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
      def remove(args = nil, opts = {})
        init(args, opts)

        if not args.nil? and not args.empty?
          remove_sites args, opts
        elsif opts['all']
          list(MrHyde.sources_sites).each do |sm|
            remove_site sm, opts
          end
        end
        build
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
      def build(args = nil, opts = {})
        init(args, opts)

        # If there is no destinarion folder then will be created
        mk_destination(opts) unless File.exist? MrHyde.destination

        if not args.nil? and not args.empty?
          build_sites args, opts 
        elsif opts["all"]
          # Build all sites and after build/rebuild the main site
          # so all global variables referent to nested site will be loaded
          build_sites sources_list, opts
        end
        # By default the main site is built
        build_main_site(opts)
      rescue Exception => e
        MrHyde.logger.error "cannot build site: #{e}"
        MrHyde.logger.error e.backtrace
      end

      # This method returns a list of nested sites
      #
      def list(path)
        entries = Dir.entries(path)
        entries.reject! { |item| item == '.' or item == '..' }
        entries
      end

      def sources_list
        list MrHyde.sources_sites
      end

      def built_list
        return [] unless File.exist? MrHyde.destination
        sources = sources_list
        builts  = list(MrHyde.destination)

        builts.select do |site|
          site if sources.include?(site)
        end
      end

      def draft_list
        return sources_list unless File.exist? MrHyde.destination
        sources = sources_list
        builts  = built_list

        sources.reject do |site|
          site if builts.include?(site)
        end
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
        File.join site_path(name), opts['config']
      end
      
      def is_main?(name)
        File.directory? File.join(name)
      end

      private

      def create_site(args, opts = {})
        begin
          if args.kind_of? Array
            args.each{ |name| raise() if is_main(name) }
          else
            raise() if is_main?(args)
          end
        rescue
          raise ArgumentError, 'The site\'s name cannot be the same than the main site name'
        end

        MrHyde::Extensions::New.process [File.join(MrHyde.sources_sites, args)], opts
        exist? args, opts
      end

      def remove_sites(args, opts = {})
        args = [args] if args.kind_of? String

        args.each do |sm|
          remove_site sm, opts
        end
      end

      def remove_site(name, opts = {})
        # OBSOLETE
        # This checking is not mandatory, never can be removed from here the main site
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
        site_names = [site_names] if site_names.kind_of? String

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
        keep_built_sites conf
        Jekyll::Commands::Build.process conf
      end

      def keep_built_sites(conf)
        conf['keep_files'] = built_list
      end

      def mk_destination(opts)
        conf = MrHyde.main_site_configuration
        Dir.mkdir conf["destination"]
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
