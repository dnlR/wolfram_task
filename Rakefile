require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Run with 'rake spec'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color',
                     '--format documentation',
                     '--require spec_helper']
end

task :default => :spec