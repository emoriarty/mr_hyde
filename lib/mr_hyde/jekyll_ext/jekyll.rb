require 'jekyll'
require 'mr_hyde'

module Jekyll
  class << self

    def logger
      @logger ||= LogAdapter.new(Stevenson.new, (ENV['JEKYLL_LOG_LEVEL'] || :error).to_sym)
    end

    def logger=(writer)
      @logger = LogAdapter.new(writer, (ENV['JEKYLL_LOG_LEVEL'] || :error).to_sym)
    end
  end
end

