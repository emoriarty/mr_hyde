require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "mr_hyde/blog"
require "fileutils"

describe "Blog" do
  let(:tmp_dir) { File.join(File.expand_path(File.dirname(__FILE__)), 'tmp') }
  let(:tmp_blog_name) { "spec_blog" }


  describe "configurations" do
  end

  describe "external file configuration" do
  end

  describe "with runtime configuration " do
    before do
      MrHyde.configure
    end

    after do 
      FileUtils.remove_dir MrHyde.configuration.root
    end

    it "can create a single blog" do
      MrHyde::Blog.create(name: tmp_blog_name).must_be :==, true
    end

    describe "can manage the blogs form class methods so" do
      before do 
        MrHyde::Blog.create name: tmp_blog_name
      end

      it "can remove a single blog" do
        MrHyde::Blog.remove(name: tmp_blog_name).must_be :==, true
      end

      it "can check if a blog exists" do
        MrHyde::Blog.exist?(tmp_blog_name).must_be :==, true
      end

      it "can build an existing blog" do
        MrHyde::Blog.build(name: tmp_blog_name).must_be :==, true
      end

      it "cannot build an non existing blog" do
        MrHyde::Blog.build name: tmp_blog_name
        MrHyde::Blog.build(name: tmp_blog_name).must_be :==, false
      end

      it "can test if a blog has been built" do
        MrHyde::Blog.build name: tmp_blog_name
        MrHyde::Blog.built?(tmp_blog_name).must_be :==, true
      end
    end
  end

end
