require 'rake'
require 'rubygems'
require 'rspec/core/rake_task'
require 'single_test'

SingleTest.load_tasks
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

