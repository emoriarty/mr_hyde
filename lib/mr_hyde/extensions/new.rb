require 'jekyll/command'
require 'jekyll/commands/new'

module MrHyde
  module Extensions
    class New < Jekyll::Commands::New 
      class << self
        def template
          site_template
        end

        def default_config_file
          File.join template, '_config.yml'
        end

        def process(args, options = {})
          raise ArgumentError.new('You must specify a path.') if args.empty?

          new_blog_path = File.expand_path(args.join(" "), Dir.pwd)
          FileUtils.mkdir_p new_blog_path
          if preserve_source_location?(new_blog_path, options)
            Jekyll.logger.abort_with "Conflict:", "#{new_blog_path} exists and is not empty."
          end

          if options["blank"]
            create_blank_site new_blog_path, options
          else 
            create_sample_files new_blog_path, options

            File.open(File.expand_path(initialized_post_name, new_blog_path), "w") do |f|
              f.write(scaffold_post_content)
            end
          end

          Jekyll.logger.info "New jekyll site installed in #{new_blog_path}."
        end

        def create_customizable_blank_site(path)
          FileUtils.mkdir(%w(_layouts _posts _drafts _sass))
        end

        def create_blank_site(path, opts)
          Dir.chdir(path) do
            create_customizable_blank_site(path) if opts['custom']
            FileUtils.touch("index.html")
          end
        end

        def create_customizable_sample_files(path)
          FileUtils.cp_r site_template + '/.', path
          FileUtils.rm File.expand_path(scaffold_path, path) 
        end

        def create_sample_files(path, opts)
          if opts['custom']
            create_customizable_sample_files path
          else
            FileUtils.cp site_template + '/index.html', path
            FileUtils.cp site_template + '/feed.xml', path
            FileUtils.cp site_template + '/about.md', path
            FileUtils.cp_r site_template + '/_posts', path
            FileUtils.rm File.expand_path(scaffold_path, path) 
          end
        end
     end
    end
  end
end
