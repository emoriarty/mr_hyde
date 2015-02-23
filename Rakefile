require "bundler/gem_tasks"
require "rake/testtask"

ENV["JEKYLL_LOG_LEVEL"] = "error"

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList["spec/*_spec.rb"]
  #t.test_files = FileList["test/*_test.rb"]
  #t.pattern = "test/*_test.rb"
  t.verbose = true
end
