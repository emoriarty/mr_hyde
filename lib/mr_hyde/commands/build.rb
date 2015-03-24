require "fileutils"

require "mr_hyde"
require "mr_hyde/configuration"
require "mr_hyde/extensions/new"
require "mr_hyde/command"
require "mr_hyde/site"

module MrHyde
  module Commands
    class Build < MrHyde::Command
      class << self
        # Options
        def process(args, opts = {})
          MrHyde::Site.build args, opts
          MrHyde.logger.info "Built process is finished, you can see the result in '#{MrHyde.destination}' folder"
        end
      end
    end
  end
end
