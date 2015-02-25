require "minitest/autorun"
require "minitest/pride"
require "mr_hyde"
require "fileutils"

describe "MrHyde" do
  before do
    MrHyde.configure
  end

  after do
    FileUtils.remove_dir MrHyde.configure.root 
  end

  describe "default configuration" do
    it "creates a new MrHyde folder with the basics" do
      MrHyde.create
      File.exist?(MrHyde.configuration.root).must_be :==, true
      File.exist?(MrHyde.configuration.sources).must_be :==, true
      File.exist?(MrHyde.configuration.destination).must_be :==, true
      File.exist?(File.join(MrHyde.configuration.root,  MrHyde.configuration.file)).must_be :==, true
    end
  end
end
