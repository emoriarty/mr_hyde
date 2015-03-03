require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "fileutils"

describe "MrHyde" do
  before do
    MrHyde.configure
    MrHyde.create
  end

  after do
    FileUtils.remove_dir MrHyde.configuration.root 
  end

    it "can build just one blog" do
      MrHyde.create :blog, :name => 'blog_test'
      MrHyde.build :name => 'blog_test'
      File.exist?(File.join MrHyde.configuration.destination, 'blog_test').must_be :==, true
    end

    it "can build an array of blogs" do
      arr_blog_names = []
      5.times { |i| arr_blog_names << "blog_test_#{i}" }
      MrHyde.create :blog, :name => arr_blog_names
      MrHyde.build :name => arr_blog_names
      arr_blog_names.each do |bn|
        File.exist?(File.join MrHyde.configuration.destination, bn).must_be :==, true
      end
    end

    it "by default builds all blogs" do
      arr_blog_names = []
      5.times { |i| arr_blog_names << "blog_test_#{i}" }
      MrHyde.create :blog, :name => arr_blog_names
      MrHyde.build
      arr_blog_names.each do |bn|
        File.exist?(File.join MrHyde.configuration.destination, bn).must_be :==, true
      end
    end

end
