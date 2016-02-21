require "minitest/autorun"
require "minitest/reporters"
require "fileutils"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"

describe "Checking if mrhyde can create new sites" do
  before do
    @tmp_dir = Dir.mktmpdir('mrhyde_new_test')
    Dir.chdir(@tmp_dir)
    @site_name = 'test'
    @nested_site_name = 'nested_site'
    @defaults = MrHyde::Configuration::DEFAULTS
  end

  after do
    FileUtils.remove_dir(@site_name) if File.exist? @site_name
  end

  it "creates a new MrHyde project in the same dir" do
    MrHyde.create

    File.exist?(File.join '.', @defaults['config']).must_be :==, true
    File.exist?(File.join '.', @defaults['layouts_dir']).must_be :==, true
    File.exist?(File.join '.', @defaults['includes_dir']).must_be :==, true
    File.exist?(File.join '.', @defaults['assets']).must_be :==, true
    File.exist?(File.join '.', @defaults['mainsite']).must_be :==, true
    File.exist?(File.join '.', @defaults['sources_sites']).must_be :==, true
    File.exist?(File.join '.', @defaults['mainsite'], 'index.md').must_be :==, true
  end

  it "creates a new MrHyde folder" do
    MrHyde.create @site_name
    
    File.exist?(@site_name).must_be :==, true
    File.exist?(File.join @site_name).must_be :==, true
    File.exist?(File.join @site_name, @defaults['config']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['layouts_dir']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['includes_dir']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['assets']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['mainsite']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['sources_sites']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['mainsite'], 'index.md').must_be :==, true
  end

  it "creates a new MrHyde blank folder" do
    MrHyde.create @site_name, 'blank' => true 
    
    File.exist?(@site_name).must_be :==, true
    File.exist?(File.join @site_name).must_be :==, true
    File.exist?(File.join @site_name, @defaults['config']).must_be :==, false
    File.exist?(File.join @site_name, @defaults['jekyll_config']).must_be :==, false
    File.exist?(File.join @site_name, @defaults['layouts_dir']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['includes_dir']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['assets']).must_be :==, false
    File.exist?(File.join @site_name, @defaults['mainsite']).must_be :==, true
    File.exist?(File.join @site_name, @defaults['sources_sites']).must_be :==, false
    File.exist?(File.join @site_name, @defaults['mainsite'], 'index.html').must_be :==, true
  end

  it "cannot create over an existing folder" do
    MrHyde.create @site_name
    lambda { MrHyde.create @site_name }.must_raise SystemExit
  end

  it "force create over an existing folder" do
    MrHyde.create @site_name
    lambda { MrHyde.create(@site_name, 'force' => true)}.must_be_silent
  end

  describe "sample files" do
    it "are generated" do
      MrHyde.create @site_name
      File.exist?(File.join @site_name, @defaults['sources_sites'], 'sample-site').must_be :==, true
      File.exist?(File.join @site_name, @defaults['sources_sites'], 'sample-full-site').must_be :==, true
    end
  end

  describe "nested sites" do
    before do
      MrHyde.create @site_name
    end
      
    it "can create a single site" do 
      Dir.chdir(@site_name) do
        MrHyde::Site.create @nested_site_name
        File.exist?(File.join @defaults['sources_sites'],  @nested_site_name).must_be :==, true
      end
    end

    it "can create an array of sites" do 
      Dir.chdir(@site_name) do
        arr_blog_names = []
        10.times { |i| arr_blog_names << "#{@nested_site_name}_#{i}" }
        MrHyde::Site.create arr_blog_names
        arr_blog_names.each do |bn|
          File.exist?(File.join @defaults['sources_sites'], bn).must_be :==, true
        end
      end
    end
  end
end
