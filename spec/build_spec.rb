require "minitest/autorun"
require "minitest/reporters"
require "nokogiri"
require "fileutils"
require "pathname"
require "yaml"
require_relative "../lib/mr_hyde"
require_relative "../lib/mr_hyde/site"
require_relative "../lib/mr_hyde/commands/build"

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

  describe "specifying another configuration file" do
    def test_for_error 
      yield
      'ok'
    rescue
      $!
    end

    def fetch_title
      # Checking the title provided by the new config file
      html_file = Pathname.pwd.join(MrHyde.configuration['destination'], 'index.html')
      doc       = Nokogiri::HTML Pathname.new(html_file)
      res       = doc.search '.row hgroup h1.site-title a'
      res.children.first.to_s
    end

    before do
      @current_file      = Pathname.new(Dir.pwd).join MrHyde.configuration['config']
      @yml_file          = YAML.load_file @current_file
      @yml_file['title'] = "Copied file title"
      @new_file          = Pathname.pwd.join("..").join(@current_file.basename)

      File.open(@new_file.to_s, "w") do |f|
        f.write @yml_file.to_yaml
      end
    end

    it "can build site when --config option is used" do
      # Building site
      test_for_error do
        MrHyde::Site.build([], {'config' => @new_file.to_s})
      end.must_equal 'ok'

      fetch_title().must_equal @yml_file['title']
    end

    it "can build all sites with --config and --all option" do
      # Building site
      test_for_error do
        MrHyde::Site.build([], {'config' => @new_file.to_s, 'all' => true})
      end.must_equal 'ok'
      
      fetch_title().must_equal @yml_file['title']
    end
  end
end
