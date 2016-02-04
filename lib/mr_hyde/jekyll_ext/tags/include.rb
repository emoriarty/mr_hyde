require 'jekyll/tags/include'
require 'mr_hyde'

include Jekyll

module Tags
  class IncludeTag
=begin
    def tag_includes_dir
      File.join MrHyde.config['includes']
=end

    def resolved_includes_dir(context)
      path = File.join(File.realpath(context.registers[:site].source), @includes_dir)

      unless File.directory? path
        path = File.join(File.realpath(MrHyde.source), @includes_dir)
      end

      path
    end
  end
end
