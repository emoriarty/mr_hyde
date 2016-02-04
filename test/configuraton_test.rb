require "minitest/autorun"
require "minitest/reporters"
require "jekyll"
require_relative "../lib/mr_hyde"

Minitest::Reporters.use!

class TestConfiguration < Minitest::Test
  def setup
    @jekyll_config = Jekyll::Configuration::DEFAULTS
    @mrhyde_config = MrHyde::Configuration::JEKYLL_DEFAULTS
  end

  def test_that_if_configuration_defaults_ids_match
  end
end
