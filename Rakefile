require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new('spec') do |task|
  task.rspec_opts = "--color"
end

task :default => :spec
