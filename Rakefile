require "bundler/gem_tasks"
require "rake/testtask"

ENV["JEKYLL_LOG_LEVEL"] = "error"
ENV["MRHYDE_LOG_LEVEL"] = "error"

task :test_task do
  Rake::TestTask.new do |t|
    t.libs.push "lib"
    t.test_files = FileList["spec/*_spec.rb"]
    #t.pattern = "test/*_test.rb"
    #t.verbose = true
  end
end

task :unit_task do
  Rake::TestTask.new("unit") do |t|
    t.libs.push "lib"
    t.test_files = FileList["test/*_test.rb"]
  end
end


task :test do
  Rake::Task["unit_task"].clear
  Rake::Task["test_task"].invoke
end

task :unit do
  Rake::Task["test_task"].clear
  Rake::Task["unit_task"].invoke
end
