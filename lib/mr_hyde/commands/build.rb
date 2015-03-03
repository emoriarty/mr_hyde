require "fileutils"

require "mr_hyde"
require "mr_hyde/configuration"
require "mr_hyde/extensions/new"
require "mr_hyde/command"
require "mr_hyde/blog"

module MrHyde
  module Commands
    class Build < MrHyde::Command
      class << self
        # Options
        def process(opts = {})
          MrHyde::Blog.build opts
        end
      end
    end
  end
end
