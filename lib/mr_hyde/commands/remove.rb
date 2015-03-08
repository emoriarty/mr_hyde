require "mr_hyde/command"
require "mr_hyde/blog"

module MrHyde
  module Commands
    class Remove < MrHyde::Command
      class << self
        def process(args, opts = {})
          Blog.remove args, opts
        end
      end
    end
  end
end
