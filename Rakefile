require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Run the code examples in spec/unit"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  desc "Run the code examples in spec/functional"
  RSpec::Core::RakeTask.new('functional') do |t|
    t.pattern = 'spec/functional/**/*_spec.rb'
  end
end
