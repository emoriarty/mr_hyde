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
      'config_file' => '_mrhyde.yml',
      'jekyll_config_file' => '_jekyll.yml'
    }

    attr_accessor :root, :sources, :destination, :config_file, :jekyll_config_file

    def initialize
      @root = DEFAULTS['root']
      @sources = DEFAULTS['sources']
      @destination = DEFAULTS['destination']
      @config_file = DEFAULTS['config_file']
      @jekyll_config_file = DEFAULTS['jekyll_config_file']

    end

    def source_path
      sources
    end

    def destination_path
      destination
    end
  end
end
