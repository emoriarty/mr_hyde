require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "fileutils"

describe "MrHyde" do
  before do
    MrHyde.configure
  end

  after do
    if File.exist? MrHyde.configuration.root
      FileUtils.remove_dir MrHyde.configuration.root 
    end
  end

  it "creates a new MrHyde folder with the basics" do
    MrHyde.create
    File.exist?(MrHyde.configuration.root).must_be :==, true
    File.exist?(MrHyde.configuration.sources).must_be :==, true
    File.exist?(MrHyde.configuration.destination).must_be :==, true
    File.exist?(File.join(MrHyde.configuration.root, MrHyde.configuration.config_file)).must_be :==, true
    File.exist?(File.join(MrHyde.configuration.root, MrHyde.configuration.jekyll_config_file)).must_be :==, true
  end

  it "cannot create over an existing project" do
    MrHyde.create
    lambda { MrHyde.create }.must_raise SystemExit
  end

  it "cannot create a blog if the root folder is not created" do
    MrHyde.create :blog, :name => 'blog_test'
    File.exist?(File.join MrHyde.configuration.sources, 'blog_test').must_be :==, false
  end

  describe "creating new blogs" do
    before do
      MrHyde.create
    end
      
    it "can create a blog" do 
      MrHyde.create :blog, :name => 'blog_test'
      File.exist?(File.join MrHyde.configuration.sources, 'blog_test').must_be :==, true
    end

    it "can create an array of blogs" do 
      arr_blog_names = []
      10.times { |i| arr_blog_names << "blog_test_#{i}" }
      MrHyde.create :blog, :name => arr_blog_names
      arr_blog_names.each do |bn|
        File.exist?(File.join MrHyde.configuration.sources, bn).must_be :==, true
      end
    end
  end
end
