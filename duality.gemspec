# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'duality'
 
Gem::Specification.new do |s|
  s.name        = "duality"
  s.version     = Duality::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joshua Mervine"]
  s.email       = ["joshua@mervine.net"]
  s.homepage    = "http://github.com/rubyops/duality/"
  s.summary     = "two caches are better then one"
  s.description = "a simple cache interface to setting and getting from two caches"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "diskcached"
  s.add_development_dependency "mongocached"
 
  s.files        = Dir.glob("lib/**/*") + %w(README.md HISTORY.md Gemfile)
  s.require_path = 'lib'
end

