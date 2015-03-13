require 'jekyll/site'
require 'mr_hyde'

include Jekyll

class Site
  alias_method :pristine_site_payload, :site_payload

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


  # This patching ensures that if the site is the main, then adds to the payload 
  # the sites value containing the sites payloads info within sources sites.
  def site_payload
    payload = pristine_site_payload

    if source == MrHyde.main_site
      path = File.join(MrHyde.source, MrHyde.sources_sites)
      site_names = Dir.entries(path).select do |entry|
        File.directory?(File.join(path, entry)) and !(entry == '.' or entry == '..' )
      end

      unless site_names.empty?
        sites_payload = site_names.map do |site_name|
          opts = MrHyde.custom_configuration(site_name)
          opts = Jekyll.configuration(opts)
          site = Site.new opts

          Utils.deep_merge_hashes site.site_payload['site'], { 'name' => site_name }
        end
        payload['site'] = Utils.deep_merge_hashes(payload['site'], { 'sites' => sites_payload })
      end
    end

    payload
  end

end
