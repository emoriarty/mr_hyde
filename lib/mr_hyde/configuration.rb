module MrHyde
  
  # Defaults 
  # root_path: user folder
  # root_name: root folder name
  #
  class Configuration < Hash
    DEFAULTS = {
      'root': 'mr_hyde',
      'source': 'sources',
      'destination': 'sites',
      'root_path': File.join(Dir.home, @root_name)
    }
    attr_accessor :root_name, 
      :root_path, 
      :source_name, 
      :destination_name 

    def initialize
      @root_name = "mr_hyde"
      @source_name = "sources"
      @destination_name = "sites"
      @root_path = File.join(Dir.home, @root_name)
    end

    def source_path
      @source_path || File.join(@root_path, @source_name)
    end

    def destination_path
      @destination_path || File.join(@root_path, @destination_name)
    end

    def source_path=(new_source)
      @source_path = new_source
    end

    def destination_path=(new_destination)
      @destination_path = (new_destination)
    end
  end
end
