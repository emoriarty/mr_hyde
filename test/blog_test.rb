require "mr_hyde"
require "mr_hyde/blog"
require "minitest/autorun"
require "minitest/unit"
require "minitest/pride"

require "fileutils"

class TestBlog < Minitest::Test
  def setup
    @tmp_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'tmp')
    @blog_dir = 'test_blog'
    MrHyde.configure do |config|
      config.root_path = @tmp_dir
    end
    MrHyde::Blog.create name: @blog_dir
  end

  def teardown
    FileUtils.remove_dir @tmp_dir
  end

  def test_create
    assert File.exist?(File.join MrHyde.configuration.source_path, @blog_dir) 
  end

  def test_remove
    MrHyde::Blog.remove name: @blog_dir
    assert !Dir.entries(MrHyde.configuration.source_path).include?(@blog_dir)
  end

  def test_build
    MrHyde::Blog.build name: @blog_dir
    assert File.exist?(File.join MrHyde.configuration.destination_path, @blog_dir)
  end

  def test_exists
    assert MrHyde::Blog.exist? @blog_dir
  end
  
  def test_is_build
    MrHyde::Blog.build name: @blog_dir
    assert MrHyde::Blog.built? @blog_dir
  end

end
