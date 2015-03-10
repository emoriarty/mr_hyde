require "fileutils"

require "jekyll"
require "jekyll/commands/serve"

require "mr_hyde"
require "mr_hyde/configuration"

module MrHyde
  module Commands
    class Serve < MrHyde::Command
      class << self
        def process(args, opts = {})
          opts = MrHyde.configuration(opts)
          Jekyll::Commands::Serve.process opts
        end
      end
    end
  end
end
