require "minitest/autorun"
require "minitest/reporters"
require "fileutils"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::ProgressReporter.new]

describe "Checking MrHyde build command" do
  before do
    @site_name = 'test'
    @nested_site_name = 'nested_site'
    @defaults = MrHyde::Configuration::DEFAULTS
    @tmp_dir = Dir.mktmpdir('mrhyde_new_test')
    Dir.chdir(@tmp_dir)
    MrHyde.create @site_name
    Dir.chdir(@site_name)
  end

  after do
    FileUtils.remove_dir(@site_name) if File.exist? @site_name
  end

  it "can build the default site (main)" do
    byebug
    MrHyde::Site.build
    File.exist?(@defaults['destination']).must_be :==, true
  end

  it "can build a single site" do
    MrHyde::Site.create @nested_site_name
    MrHyde::Site.build @nested_site_name
    File.exist?(File.join @defaults['destination'], @nested_site_name).must_be :==, true
  end

  it "can build an array of sites" do
    site_names = []
    5.times { |i| site_names << "#{@nested_site_name}_#{i}" }
    MrHyde::Site.create site_names
    MrHyde::Site.build site_names
    site_names.each do |sn|
      File.exist?(File.join @defaults['destination'], sn).must_be :==, true
    end
  end

  it "can build all nested sites with --all option" do
    site_names = []
    5.times { |i| site_names << "#{@nested_site_name}_#{i}" }
    MrHyde::Site.create site_names
    MrHyde::Site.build [], { 'all' => true } 
    site_names.each do |sn|
      File.exist?(File.join @defaults['destination'], sn).must_be :==, true
    end
  end

  describe "building posts" do
    it "all sites build a post within mrhyde or jekyll dir" do
      MrHyde::Site.build nil, {'all' => true}
      MrHyde::Site.built_list.each do |ns|
        (File.exist?(File.join @defaults['destination'], ns, 'mrhyde') || 
        File.exist?(File.join @defaults['destination'], ns, 'jekyll')).must_be :==, true
      end
    end
  end

end
