require 'jekyll/commands/new'

module MrHyde
  module Commands
    class New < Jekyll::Commands::New
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
