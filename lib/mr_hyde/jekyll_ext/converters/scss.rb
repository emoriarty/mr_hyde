require 'jekyll/converters/scss'
require 'mr_hyde'

include Jekyll

module Converters
  class Scss
    alias_method :pristine_sass_load_paths, :sass_load_paths

    def sass_load_paths
      paths = pristine_sass_load_paths
      puts "\nConverters Sass sass_load_paths"
      common_assets = Jekyll.sanitized_path(File.join(MrHyde.sources, MrHyde.config['assets']), sass_dir)
      paths << common_assets if File.directory? common_assets
      puts paths
      puts "\n"

      paths
    end
  end
end
