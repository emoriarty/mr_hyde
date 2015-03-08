require "fileutils"

require "jekyll"

require "mr_hyde"
require "mr_hyde/configuration"
require "mr_hyde/extensions/new"
require "mr_hyde/command"
require "mr_hyde/blog"

module MrHyde
  module Commands
    class Remove < MrHyde::Command
      class << self
        def process(args, opts = {})
        end
      end
    end
  end
end
