#!/usr/bin/env rake
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs = ["lib", "test"]
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
