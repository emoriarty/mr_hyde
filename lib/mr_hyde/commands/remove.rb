require "mr_hyde/command"
require "mr_hyde/site"

module MrHyde
  module Commands
    class Remove < MrHyde::Command
      class << self
        def process(args, opts = {})
          if args.length == 0
          MrHyde.logger.warn("A site name must be typed. You can see a list of nested sites using the 'list' command.") 
          else
            Site.remove args, opts
          end
        end
      end
    end
  end
end
