require "mr_hyde/version"
require "mr_hyde/blog"
require "mr_hyde/configuration"
require "mr_hyde/commands/new"
require "mr_hyde/commands/build"

require "logger"
require "fileutils"

require "jekyll/stevenson"
require "jekyll/log_adapter"
require "jekyll/utils"

module MrHyde
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def configuration(override = Hash.new)
      config = Configuration[Configuration::DEFAULTS]
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

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    def logger
      Jekyll.logger
    end

    # Creates the folders for the sources and destination, 
    # by default will be created under root folder.
    # Copies the default _config.yml for all blogs, in root folder.
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
        create_black_site new_site_path
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
      FileUtils.copy_file MrHyde::Extensions::New.default_config_file, 
        File.join(path, '_jekyll.yml')
      Dir.chdir(path) do
        FileUtils.mkdir(%w(sources)) unless File.exist? 'sources'
        Blog.create ['welcome_site'], { 'force' => 'force' }
      end

    end

    def site_template
      File.expand_path("./site_template", File.dirname(__FILE__))
    end
  end

end
