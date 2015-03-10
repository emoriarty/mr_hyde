require "jekyll/configuration"

module MrHyde

  class Configuration < Jekyll::Configuration

    DEFAULTS = {
      'sources' => 'sources',
      'destination' => 'site',
      'config' => '_mrhyde.yml',
      'jekyll_config' => '_jekyll.yml'
    }
    
    def read_config_files(files)
      configuration = clone

      begin
        files.each do |config_file|
          new_config = read_config_file(config_file)
          configuration = Jekyll::Utils.deep_merge_hashes(configuration, new_config)
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
