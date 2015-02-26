require "jekyll/command"

def command_class; Jekyll::Command; end

module MrHyde
  class Command < command_class
    class << self
      # Create a full Jekyll configuration with the options passed in as overrides
      # 
      # options - the configuration overrides
      # 
      # Returns a full MrHyde configuration
      def configuration_from_options(options)
        configure(options)
      end
      
      def configuration
        MrHyde.configuration
      end
    end
  end
end
