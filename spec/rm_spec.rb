require "minitest/autorun"
require "minitest/pride"
require "fileutils"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"

describe "MrHyde" do
  before do
    @tmp_dir = Dir.mktmpdir('mrhyde_new_test')
    @site_name = 'test'
    @nested_site_name = 'nested_site'
    @defaults = MrHyde::Configuration::DEFAULTS
    Dir.chdir(@tmp_dir)
    MrHyde.create @site_name
    Dir.chdir(@site_name)
  end

  after do
    FileUtils.remove_dir(@tmp_dir) if File.exist? @tmp_dir
  end

  # Helpers
  def create_build_remove(site, opts = {})
    MrHyde::Site.create site
    MrHyde::Site.build site
    if opts['all']
      MrHyde::Site.remove [], opts
    else
      MrHyde::Site.remove site, opts
    end
  end

  def remove_site(site, opts = {})
    create_build_remove site, opts
    File.exist?(File.join @defaults['sources'], @defaults['sources_sites'], site).must_be :==, (opts['full'] ? false : true)
    File.exist?(File.join @defaults['destination'], site).must_be :==, false
  end
  
  def remove_sites(name, sites_number, opts = {})
    site_names = []
    sites_number.times { |i| site_names << "#{name}_#{i}" }

    create_build_remove site_names, opts
    site_names.each do |sn|
      File.exist?(File.join @defaults['sources'], @defaults['sources_sites'], sn).must_be :==, (opts['full'] ? false : true)
      File.exist?(File.join @defaults['destination'], sn).must_be :==, false
    end
  end

  # Specs
  it "can remove a built site" do
    remove_site @nested_site_name
  end

  it "can remove a list of built sites" do
    remove_sites @nested_site_name, 5
  end

  it "can remove all built sites" do
    remove_sites @nested_site_name, 5, { 'all' => 'all' }
  end
  
  it "can remove a site completely" do
    remove_site @nested_site_name, { 'full' => 'full' }
  end

  it "can remove a list of sites completely" do
    remove_sites @nested_site_name, 5, { 'full' => 'full' }
  end

  it "can remove all sites completely" do
    remove_sites @nested_site_name, 5, { 'all' => 'all', 'full' => 'full' }
  end
end
