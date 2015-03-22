require "mr_hyde/command"
require "mr_hyde/site"

module MrHyde
  module Commands
    class List < MrHyde::Command
      class << self

        def process(opts)
          MrHyde.configuration

          if opts['built']
            show_built_sites
          else 
            show_sources_sites
          end
        end

        def show_built_sites
          sources_list = Site.list(MrHyde.sources_sites)

          if File.exist? MrHyde.destination
            built_sites = Site.list(MrHyde.destination)
            built_sites.reject! do |site|
              site unless sources_list.include?(site)
            end
            show_list "Built sites (#{MrHyde.destination})", built_sites
          else
            MrHyde.logger.warn "Still there is not a built site"
          end
        end

        def show_sources_sites
          show_list "Source Sites (#{MrHyde.sources_sites})", Site.list(MrHyde.sources_sites)
        end

        def show_list(title, list)
          puts
          MrHyde.logger.info "#{title}\n#{'-' * title.length}"
          list.each do |site|
            MrHyde.logger.info site
          end
          puts
        end

      end
    end
  end
end
