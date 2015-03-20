require "fileutils"
require "logger"

require "jekyll/log_adapter"
require "jekyll/utils"

require "mr_hyde/version"
require "mr_hyde/site"
require "mr_hyde/configuration"
require "mr_hyde/commands/new"
require "mr_hyde/commands/build"

module MrHyde
  require "mr_hyde/jekyll_ext/site"
  require "mr_hyde/jekyll_ext/tags/include"
  require "mr_hyde/jekyll_ext/converters/scss"

  class << self
    attr_reader :source, :config
    attr_accessor :configuration

    # OBSOLETE
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    # Mr.Hyde Configuration
    def configuration(override = Hash.new)
      @config = private_configuration(override, Configuration::DEFAULTS)
      @source = File.expand_path(config['source']).freeze
      @config
    end
    
    # Jekyll Configuration
    def main_site_configuration
      # The order is important here, the last one overrides the previous ones
      site_configuration nil
    end
  
    # Jekyll per site configuration
    # This method gets the config files which must be read from jekyll. 
    # _config.yml < sources/sites/site/_config.yml < override
    #
    def site_configuration(site_name = nil)
      jekyll_config = jekyll_defaults(site_name)
      site_name ||= config['mainsite']
      opts = {}

      # The order is important here, the last one overrides the previous one
      opts['config'] = []
      opts['config'] << Jekyll.sanitized_path(source, config['jekyll_config']) if has_jekyll_config?
      opts['config'] << Site.custom_config(site_name, config) if Site.has_custom_config?(site_name, config)

      jekyll_config.merge(opts)
    end
    
    # If no site name is passed in then the configuration defaults are set for the main site
    def jekyll_defaults(site_name = nil)
      conf = if site_name
        { 'baseurl'     => '/' + site_name,
          'destination' => File.join(MrHyde.destination, site_name),
          'source'      => File.join(MrHyde.sources_sites, site_name) }
      else
        site_name = config['mainsite']
        { 'source' => File.join(sources, site_name),
          'destination' => File.join(MrHyde.destination) }
      end

      conf.merge({ 'layouts' => File.join(MrHyde.sources, config['layouts']) })
    end

    def has_jekyll_config?
      File.exist? File.expand_path(source, @config['jekyll_config'])
    end

    def sources
      config['sources']
    end
    
    def sources_sites
      File.join config['sources'], config['sources_sites']
    end

    def destination
      config['destination']
    end

    def main_site
      File.join source, sources, config['mainsite']
    end

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    def logger
      Jekyll.logger
    end

    # Creates the folders for the sources and destination, 
    # by default will be created under root folder.
    # Copies the default _config.yml for all sites, in root folder.
    #
    # Throws a SystemExit exception
    #
    def create(args, opts = {})
      args = [args] if args.kind_of? String
      new_site_path = File.expand_path(args.join(" "), Dir.pwd)
      FileUtils.mkdir_p new_site_path
      if preserve_source_location?(new_site_path, opts)
        raise SystemExit.new "#{new_site_path} exists and is not empty."
      end

      if opts['blank']
        create_blank_site new_site_path
      else
        create_sample_files new_site_path
      end
      new_site_path
    end

    def build(opts = {})
      Commands::Build.process opts
    end

    private 

    def preserve_source_location?(path, opts)
      !opts["force"] && !Dir["#{path}/**/*"].empty?
    end

    def create_sample_files(path)
      FileUtils.cp_r site_template + '/.', path
      # Copying the original _config.yml from jekyll to mrhyde folder
      # jekyll_config = MrHyde::Extensions::New.default_config_file
      # FileUtils.copy_file(jekyll_config, File.join(path, File.basename(jekyll_config)))
      # Creating the default jekyll site in mrhyde
      Dir.chdir(path) do
        FileUtils.mkdir(%w(sources)) unless File.exist? 'sources'
        Site.create ['sample-site'], { 'force' => 'force' }
        Site.create ['sample-full-site'], { 'full' => 'full', 'force' => 'force' }
      end
    end

    def create_blank_site(path)
      Dir.chdir(path) do
        FileUtils.mkdir('sources')
        Dir.chdir('sources') do 
          FileUtils.mkdir %w(_layouts _includes main_site) 
        end
        Dir.chdir(File.join('sources', 'main_site')) do
          FileUtils.touch 'index.html' 
        end
      end
    end

    def site_template
      File.expand_path("./site_template", File.dirname(__FILE__))
    end

    def private_configuration(override = Hash.new, defaults)
      config = Configuration[defaults]
      override = Configuration[override].stringify_keys

      unless override.delete('skip_config_files')
        override['config'] ||= config['config']
        config = config.read_config_files(config.config_files(override))
      end
      # Merge DEFAULTS < _config.yml < override
      config = Jekyll::Utils.deep_merge_hashes(config, override).stringify_keys
      set_timezone(config['timezone']) if config['timezone']

      config
    end
  end

end
