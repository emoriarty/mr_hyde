module MrHyde
  
  # Defaults 
  # root_path: user folder
  # root_name: root folder name
  #
  class Configuration

    DEFAULTS = {
      'root' => File.join(Dir.pwd, 'mr_hyde'),
      'sources' => File.join(Dir.pwd, 'mr_hyde', 'sources'),
      'destination' => File.join(Dir.pwd, 'mr_hyde', 'sites'),
      'config_file' => '_config.yml'
    }

    attr_accessor :root, :sources, :destination, :file

    def initialize
      @root = DEFAULTS['root']
      @sources = DEFAULTS['sources']
      @destination = DEFAULTS['destination']
      @file = DEFAULTS['config_file']
    end

    def source_path
      sources
    end

    def destination_path
      destination
    end
  end
end
