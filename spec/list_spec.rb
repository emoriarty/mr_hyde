require "minitest/autorun"
require "minitest/pride"
require "fileutils"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"

describe "Mr. Hyde Listing" do
  before do
    @site_name = 'test'
    @nested_site_name = 'nested_site'
    @defaults = MrHyde::Configuration::DEFAULTS
    @tmp_dir = Dir.mktmpdir('mrhyde_new_test')
    Dir.chdir(@tmp_dir)
    MrHyde.create @site_name, { 'blank' => true }
    Dir.chdir(@site_name)
  end

  after do
    Dir.chdir(@tmp_dir)
    FileUtils.remove_dir(@site_name) if File.exist? @site_name
  end

  def create_sites(sites_number)
    sites_name = []
    sites_number.times { |i| sites_name << "#{@nested_site_name}_#{i}" } 
    MrHyde::Site.create sites_name, { 'blank' => true }
  end

  def build_sites(sites_number = 0)
    entries = fetch_entries(MrHyde.sources_sites)
    sites_number = entries.length if sites_number == 0

    MrHyde::Site.build entries[0..sites_number - 1]
  end

  def fetch_entries(path)
    entries = Dir.entries path
    entries.reject{ |entry| entry == '.' or entry == '..' }
  end

  it "can list all sites in sources" do
    create_sites(5)
    MrHyde.sources_list.length.must_be :==, 5 
  end

  it "can list all built sites" do
    create_sites(5)
    build_sites(3)
    MrHyde.built_list.length.must_be :==, 3
  end

  it "can list all draft sites" do
    create_sites(5)
    build_sites(3)
    MrHyde.draft_list.length.must_be :==, 2 
  end
end
