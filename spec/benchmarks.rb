#!/usr/bin/env ruby
require 'benchmark'
require 'mongocached'
require 'diskcached'
require File.join(File.dirname(__FILE__), '..', 'lib', 'duality')

# benchmarks helpers

def large_hash
  hash = {}
  (1..100).each do |i|
    hash["key#{i}"] = "foo"*100
  end
  return hash
end
# Set up data sets #
LARGE_HASH = large_hash
SMALL_STR  = "foo"
TIMES      = 100000

# print ruby version as header
puts "## Ruby #{`ruby -v | awk '{print $2}'`.chomp}"

  diskcache  = Diskcached.new('/tmp/benchmark')
  mongocache = Mongocached.new#( host: 'jmervine04.np.wc1.yellowpages.com' )
  cache = Duality.new(diskcache, mongocache)

  puts " "
  puts "#### small string * #{TIMES}"
  dataset = SMALL_STR

  diskcache.set('read', dataset)
  mongocache.set 'read', dataset

  Benchmark.bm do |b|
    b.report('disk.set') do
      (1..TIMES).each do
        diskcache.set('write', dataset)
      end
    end
    b.report('mong.set') do
      (1..TIMES).each do
        mongocache.set 'write', dataset
      end
    end
    b.report('dual.set') do
      (1..TIMES).each do
        cache.set 'write', dataset
      end
    end
    b.report('disk.get') do
      (1..TIMES).each do
        x = diskcache.get('read') 
      end
    end
    b.report('mong.get') do
      (1..TIMES).each do
        mongocache.get 'read'
      end
    end
    b.report('dual.get') do
      (1..TIMES).each do
        cache.get 'read'
      end
    end
  end

  diskcache.flush

  puts " "
  puts " "
  puts "#### large hash * #{TIMES}"
  dataset = LARGE_HASH

  diskcache.cache('read') { dataset }
  mongocache.set 'read', dataset
  Benchmark.bm do |b|
    b.report('disk.set') do
      (1..TIMES).each do
        diskcache.set('write', dataset)
      end
    end
    b.report('mong.set') do
      (1..TIMES).each do
        mongocache.set 'write', dataset
      end
    end
    b.report('dual.set') do
      (1..TIMES).each do
        cache.set 'write', dataset
      end
    end
    b.report('disk.get') do
      (1..TIMES).each do
        x = diskcache.get('read') 
      end
    end
    b.report('mong.get') do
      (1..TIMES).each do
        mongocache.get 'read'
      end
    end
    b.report('dual.get') do
      (1..TIMES).each do
        cache.get 'read'
      end
    end
  end

