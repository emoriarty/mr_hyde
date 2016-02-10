require 'jekyll/command'
require 'jekyll/commands/new'

module MrHyde
  module Extensions
    class New < Jekyll::Commands::New 
      class << self
        def subsite_template
          File.expand_path "../../subsite_template", File.dirname(__FILE__)
        end

        def template
          site_template
        end

        def default_config_file
          File.join template, '_config.yml'
        end

        def process(args, options = {})
          raise ArgumentError.new('You must specify a path.') if args.empty?

          new_site_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_site_path
          if preserve_source_location?(new_site_path, options)
            Jekyll.logger.abort_with "Conflict:", "#{new_site_path} exists and is not empty."
          end

          if options["blank"]
            create_blank_site new_site_path, options
            Jekyll.logger.info "New jekyll site installed in #{new_site_path}."
          elsif options["full"]
            create_independant_sample_files args, options
          else 
            create_sample_files new_site_path, options

            File.open(File.expand_path(initialized_post_name, new_site_path), "w") do |f|
              f.write(scaffold_post_content)
            end
            Jekyll.logger.info "New jekyll site installed in #{new_site_path}."
          end

        end

        def create_blank_site(path, opts)
          Dir.chdir(path) do
            FileUtils.mkdir(%w(_posts _drafts))
            FileUtils.touch("index.html")
          end
        end

        def create_sample_files(path, opts)
          FileUtils.cp_r subsite_template + '/.', path
          FileUtils.cp_r subsite_template + '/_posts', path
          FileUtils.rm File.expand_path(scaffold_path, path) 
        end
        
        def create_independant_sample_files(args, opts)
          Jekyll::Commands::New.process args, opts
        end

        def scaffold_post_content
            ERB.new(File.read(File.expand_path(scaffold_path, subsite_template))).result
        end

        def initialized_post_name
          "_posts/#{Time.now.strftime('%Y-%m-%d')}-welcome-to-mr-hyde.markdown"
        end

        def scaffold_path
          "_posts/0000-00-00-welcome-to-mr-hyde.markdown.erb"
        end
      end
    end
  end
end
