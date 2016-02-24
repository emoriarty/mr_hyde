require "jekyll/configuration"

module MrHyde

  class Configuration < Jekyll::Configuration
    DEFAULTS.merge!({
      # Places
      'source'        => Dir.pwd,
      'destination'   => 'site',
      'sources_sites' => '_sites',
      'config'        => '_config.yml',
      'assets'        => '_assets',
      'mainsite'      => '_site'
    })

    def config_files(override)
      MrHyde.logger.adjust_verbosity(:quiet => quiet?(override), :verbose => verbose?(override))
      super(override)
    end

    def read_config_files(files)
      configuration = clone

      begin
        files.each do |config_file|
          if File.exist? config_file
            new_config = read_config_file(config_file)
            configuration = Jekyll::Utils.deep_merge_hashes(configuration, new_config)
          end
        end
      rescue ArgumentError => err
        MrHyde.logger.warn "WARNING:", "Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
      end
      configuration
    end
  end
end
