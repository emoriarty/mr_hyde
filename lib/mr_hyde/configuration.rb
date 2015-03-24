require "jekyll/configuration"

module MrHyde

  class Configuration < Jekyll::Configuration

    DEFAULTS = {
      # Places
      'source'        => Dir.pwd,
      'sources'       => 'sources',
      'sources_sites' => '_sites',
      'destination'   => 'site',
      'layouts'       => '_layouts',
      'includes'      => '_includes',
      'config'        => '_mrhyde.yml',
      'jekyll_config' => '_config.yml',
      'assets'        => '_assets',
      'mainsite'      => 'main_site',
      # Serving
      'detach'  => false, # default to not detaching the server
      'port'    => '4000',
      'host'    => '127.0.0.1',
      'baseurl' => ''
    }

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
