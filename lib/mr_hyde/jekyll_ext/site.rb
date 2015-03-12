require 'jekyll/site'
require 'mr_hyde'

include Jekyll

class Site

  # First try to find the file referenced in the jekyll folder (by default _config.yml),
  # in case is not there, then try to find it in the mrhyde folder (by default _config.yml)
  def in_source_dir(*paths)
    file_path = paths.reduce(source) do |base, path|
      Jekyll.sanitized_path(base, path)
    end
    unless File.exist? file_path
      file_path = paths.reduce(MrHyde.source) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end
    file_path
  end

end
