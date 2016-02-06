require "minitest/autorun"
require "minitest/pride"
require "fileutils"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"

describe "Checking if MrHyde can build sites" do
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

  it "can build the default site (main)" do
    MrHyde::Site.build
    File.exist?(@defaults['destination']).must_be :==, true
  end

  it "can build a single site" do
    MrHyde::Site.create @nested_site_name
    MrHyde::Site.build @nested_site_name
    File.exist?(File.join @defaults['destination'], @nested_site_name).must_be :==, true
  end

  it "can build an array of sites" do
    site_names = []
    5.times { |i| site_names << "#{@nested_site_name}_#{i}" }
    MrHyde::Site.create site_names
    MrHyde::Site.build site_names
    site_names.each do |sn|
      File.exist?(File.join @defaults['destination'], sn).must_be :==, true
    end
  end

  it "can build all sites in sources path" do
    site_names = []
    5.times { |i| site_names << "#{@nested_site_name}_#{i}" }
    MrHyde::Site.create site_names
    MrHyde::Site.build [], { 'all' => 'all' } 
    site_names.each do |sn|
      File.exist?(File.join @defaults['destination'], sn).must_be :==, true
    end
  end

end
