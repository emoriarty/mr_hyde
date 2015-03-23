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
    MrHyde.create @site_name
    Dir.chdir(@site_name)
  end

  after do
    FileUtils.remove_dir(@site_name) if File.exist? @site_name
  end

  def fetch_entries(path)
    entries = Dir.entries path
    entries.reject{ |entry| entry == '.' or entry == '..' }
  end

  it "can list all sites in sources" do
    MrHyde.sources_list.length.must_be :==, fetch_entries(MrHyde.sources_sites).length 
  end

  it "can list all built sites" do
    sources = MrHyde.sources_list
    entries = MrHyde::Site.build [], { 'all' => true }
    entries.select! { |entry| entry if sources.include? entry }
    MrHyde.built_list.length.must_be :==, entries.length 
  end
end
