require "mr_hyde/version"
require "jekyll"

module MrHyde
  class MrHyde
    # Static methods
    class << self
      def hello
        "Hello you!"
      end

      def blog(action, opts)
        if :new == action
          Jekyll::Commands::New.process opts[:path]
        end
      end
    end
  end
end
