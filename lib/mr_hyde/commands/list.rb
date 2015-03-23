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
          if File.exist? MrHyde.destination
            show_list "Built sites (#{MrHyde.destination})", Site.built_list
          else
            MrHyde.logger.warn "Still there is not a built site"
          end
        end

        def show_sources_sites
          show_list "Source Sites (#{MrHyde.sources_sites})", Site.sources_list
        end

        def show_list(title, list)
          MrHyde.logger.info "#{title}\n#{'-' * title.length}"
          list.each do |site|
            MrHyde.logger.info site
          end
        end

      end
    end
  end
end
