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
        end
      end
    end
  end
end
