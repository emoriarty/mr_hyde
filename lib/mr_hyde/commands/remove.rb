require "mr_hyde/command"
require "mr_hyde/site"

module MrHyde
  module Commands
    class Remove < MrHyde::Command
      class << self
        def process(args, opts = {})
          Site.remove args, opts
        end
      end
    end
  end
end
