require 'jekyll/command'
require 'jekyll/commands/new'

def new_class; Jekyll::Commands::New; end

module MrHyde
  module Jekyll
    class New < new_class 
      class << self
        def template
          site_template
        end

        def default_config_file
          File.join template, '_config.yml'
        end

        def create_sample_site
          create_sample_files
        end

     end
    end
  end
end
