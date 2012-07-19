#!/usr/bin/env ruby
# @author Joshua Mervine <jmervine@mervine.net>

require 'simplecov'
SimpleCov.start do
    add_filter "/vendor/"
end
require 'rspec'
require 'fileutils'
require './lib/duality'
require 'diskcached'
require 'mongocached'

$fast = Diskcached.new
$slow = Mongocached.new

