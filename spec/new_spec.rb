require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "mr_hyde/blog"
require "fileutils"

describe "MrHyde" do
  before do
    #@path = Dir.mktmpdir('mrhyde_new_test')
    @path = 'mrhyde_new_test'
  end

  after do
    FileUtils.remove_dir(@path) if File.exist? @path
  end

  it "creates a new MrHyde folder with the basics" do
    MrHyde.create @path
    
    File.exist?(@path).must_be :==, true
    File.exist?(File.join @path, MrHyde::Configuration::DEFAULTS['sources']).must_be :==, true
    File.exist?(File.join @path, MrHyde::Configuration::DEFAULTS['destination']).must_be :==, true
    File.exist?(File.join @path, MrHyde::Configuration::DEFAULTS['config']).must_be :==, true
    File.exist?(File.join @path, MrHyde::Configuration::DEFAULTS['jekyll_config']).must_be :==, true
  end

  it "cannot create over an existing project" do
    MrHyde.create @path
    lambda { MrHyde.create @path }.must_raise SystemExit
  end

  describe "creating new sites" do
    before do
      MrHyde.create @path
    end
      
    it "can create a single site" do 
      Dir.chdir(File.join Dir.pwd, @path) do
        MrHyde::Blog.create 'site_test'
        File.exist?(File.join MrHyde::Configuration::DEFAULTS['sources'], 'site_test').must_be :==, true
      end
    end

    it "can create an array of sites" do 
      Dir.chdir(File.join Dir.pwd, @path) do
        arr_blog_names = []
        10.times { |i| arr_blog_names << "site_test_#{i}" }
        MrHyde::Blog.create arr_blog_names
        arr_blog_names.each do |bn|
          File.exist?(File.join MrHyde::Configuration::DEFAULTS['sources'], bn).must_be :==, true
        end
      end
    end
  end
end
