require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "mr_hyde/blog"
require "fileutils"

describe "MrHyde" do
  before do
    @path = 'mthyde_build_test'
    MrHyde.create @path
  end

  after do
    FileUtils.remove_dir(@path) if File.exist? @path
  end

  it "can build a single site" do
    Dir.chdir(File.join Dir.pwd, @path) do
      MrHyde::Blog.create 'site_test'
      MrHyde::Blog.build 'site_test'
      File.exist?(File.join MrHyde::Configuration::DEFAULTS['destination'], 'site_test').must_be :==, true
    end
  end

  it "can build an array of sites" do
    Dir.chdir(File.join Dir.pwd, @path) do
      site_names = []
      5.times { |i| site_names << "site_test_#{i}" }
      MrHyde::Blog.create site_names
      MrHyde::Blog.build site_names
      site_names.each do |bn|
        File.exist?(File.join MrHyde::Configuration::DEFAULTS['destination'], bn).must_be :==, true
      end
    end
  end

  it "can build all sites in sources path" do
    Dir.chdir(File.join Dir.pwd, @path) do
      site_names = []
      5.times { |i| site_names << "blog_test_#{i}" }
      MrHyde::Blog.create site_names
      MrHyde::Blog.build [], { 'all' => 'all' } 
      site_names.each do |bn|
        File.exist?(File.join MrHyde::Configuration::DEFAULTS['destination'], bn).must_be :==, true
      end
    end
  end

end
