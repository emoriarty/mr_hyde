require "mr_hyde/blog"
require "minitest/autorun"
require "minitest/unit"
require "minitest/pride"

require "fileutils"

class TestBlog < Minitest::Test
  def setup
    @tmp_dir = 'tmp'
    @blog_dir = 'test_blog'
    @test_dir = "#{@tmp_dir}#{File::SEPARATOR}#{@blog_dir}"
    # create dir to store test content
    FileUtils.mkdir @tmp_dir
  end

  def teardown
    FileUtils.remove_dir @tmp_dir
  end

  def test_create_blog
    MrHyde::Blog.create path: [@test_dir]
    assert File.exist?(@test_dir) 
  end

  def test_remove_blog
    MrHyde::Blog.create path: [@test_dir]
    MrHyde::Blog.remove path: @test_dir
    assert !File.exist?("./@test_dir") 
  end
end
