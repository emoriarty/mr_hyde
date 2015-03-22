require "fileutils"

require "jekyll"
require "jekyll/stevenson"
require "jekyll/commands/serve"

require "mr_hyde"
require "mr_hyde/configuration"

module MrHyde
  module Commands
    class Serve < MrHyde::Command
      class << self
        def process(opts = {})
          opts = MrHyde.configuration(opts)
          unless File.exist? MrHyde.destination
            MrHyde.logger.abort_with "Cannot start server: There is no built content"
          end
          ENV['JEKYLL_LOG_LEVEL'] = 'info'
          Jekyll.logger = Stevenson.new
          Jekyll::Commands::Serve.process opts
        end
      end
    end
  end
end
