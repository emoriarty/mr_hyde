require "mr_hyde/version"
require "mr_hyde/configuration"
require "jekyll"

module MrHyde
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= MrHyde::Configuration.new
    yield(configuration) if block_given?

    self.configuration
  end

end
