# -*- ruby -*-

require 'rubygems'
require 'rspec/core/rake_task'
require './lib/duality'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task :rdoc do
  puts ` set -x; rdoc -f rubydoc -t "Duality #{Duality::VERSION}" ./lib/**/*.rb `
end

task :benchmark do
  load './spec/benchmarks.rb'
end

task :package do
  puts %x{ gem build duality.gemspec && (mkdir ./pkg; mv *.gem ./pkg/ ) }
end

# vim: syntax=ruby
