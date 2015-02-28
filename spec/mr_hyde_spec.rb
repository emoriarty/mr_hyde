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

  describe "default configuration" do
    it "creates a new MrHyde folder with the basics" do
      MrHyde.create
      File.exist?(MrHyde.configuration.root).must_be :==, true
      File.exist?(MrHyde.configuration.sources).must_be :==, true
      File.exist?(MrHyde.configuration.destination).must_be :==, true
      File.exist?(File.join(MrHyde.configuration.root,  MrHyde.configuration.config_file)).must_be :==, true
      File.exist?(File.join(MrHyde.configuration.root,  MrHyde.configuration.jekyll_config_file)).must_be :==, true
    end

    it "cannot create over an existing project" do
      MrHyde.create
      lambda { MrHyde.create }.must_raise SystemExit
    end

    
  end
end
