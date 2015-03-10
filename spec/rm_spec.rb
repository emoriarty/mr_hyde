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


end
