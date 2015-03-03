require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "fileutils"

describe "MrHyde" do
  before do
    MrHyde.configure
  end

  after do
    FileUtils.remove_dir MrHyde.configuration.root 
  end

  describe "CRUD" do
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

    it "can create a blog" do 
      MrHyde.create :blog, :name => 'blog_test'
      File.exist?(File.join MrHyde.configuration.sources, 'blog_test').must_be :==, true
    end

    it "can create an array of blogs" do 
      skip
      lambda {
      10.times do |i|
        MrHyde.create :blog, 'blog_test_'.concat(i) 
      end }.wont_raise Exception
    end

    it "can build just one blog" do
      MrHyde.create :blog, :name => 'blog_test'
      MrHyde.build :name => 'blog_test'
      File.exist?(File.join MrHyde.configuration.destination, 'blog_test').must_be :==, true
    end

    it "can build all blogs" do
      skip
      MrHyde.create
      5.times do |key|
        MrHyde.create :blog, :name => 'blog_'.concat(key)
      end
      MrHyde.build :all
    end

    it "can remove all blogs" do 
      skip "wait to build blog method"
    end
    

    it "can remove just one blog" do
      skip "wait to build blogs"
    end
  end
end
