require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "mr_hyde/blog"
require "fileutils"

describe "MrHyde" do
  before do
    #@path = Dir.mktmpdir('mrhyde_new_test')
    @path = 'mrhyde_new_test'
    @site = 'site_test'
    MrHyde.create @path
  end

  after do
    FileUtils.remove_dir(@path) if File.exist? @path
  end

  # Helpers
  def create_build_remove(site, opts = {})
    MrHyde::Blog.create site
    MrHyde::Blog.build site
    if opts['all']
      MrHyde::Blog.remove [], opts
    else
      MrHyde::Blog.remove site, opts
    end
  end

  def remove_site(path, site, opts = {})
    Dir.chdir(File.join Dir.pwd, path) do
      create_build_remove site, opts
      File.exist?(File.join MrHyde::Configuration::DEFAULTS['sources'], site).must_be :==, (opts['full'] ? false : true)
      File.exist?(File.join MrHyde::Configuration::DEFAULTS['destination'], site).must_be :==, false
    end
  end
  
  def remove_sites(path, sites_number, opts = {})
    site_names = []
    sites_number.times { |i| site_names << "site_test_#{i}" }

    Dir.chdir(File.join Dir.pwd, path) do
      create_build_remove site_names, opts
      site_names.each do |sn|
        File.exist?(File.join MrHyde::Configuration::DEFAULTS['sources'], sn).must_be :==, (opts['full'] ? false : true)
        File.exist?(File.join MrHyde::Configuration::DEFAULTS['destination'], sn).must_be :==, false
      end
    end
  end

  # Specs
  it "can remove a built site" do
    remove_site @path, @site
  end

  it "can remove a list of built sites" do
    remove_sites @path, 5
  end

  it "can remove all built sites" do
    remove_sites @path, 5, { 'all' => 'all' }
  end
  
  it "can remove a site completely" do
    remove_site @path, @site, { 'full' => 'full' }
  end

  it "can remove a list of sites completely" do
    remove_sites @path, 5, { 'full' => 'full' }
  end

  it "can remove all sites completely" do
    remove_sites @path, 5, { 'all' => 'all', 'full' => 'full' }
  end
end
