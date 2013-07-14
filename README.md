# Duality

Duality is a simple cache helper for using multiple caches. The idea is that you have local cache and a shared cache -- or fast and slow cache -- and want to save to both, and read from local, if present and shared if not. The idea came from [Hector Virgen](http://www.virgentech.com/) (the PHP Zend Jedi Ninja Badass) and [Zend_Cache_Backend_TwoLevels](http://framework.zend.com/manual/en/zend.cache.backends.html#zend.cache.backends.twolevels), which does basically the same thing in PHP.

A few things to note:

* It currently implements the methods of my other two cache projects -- [Diskcached](http://mervine.net/gems/diskcached) and [Monogocached](http://mervine.net/gems/mongocached), both which take their implementation from the popular [Memcached](https://rubygems.org/gems/memcached).
* ~~I'm working on a Rails implementation, which uses [ActiveSupport::Cache::Store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html) -- more to come on that later.~~ I haven't had time to work on this, contributions are welcome.
* My origional intent was to make sets asynchronous, but benchmarking shows that to be less efficent due either to my lack of knowledge in threaded development, or -- based on what I'm reading -- ruby inefficenies in threading.


### Installation

    :::shell
    gem install duality

Or via bundler:

    :::ruby
    # file: Gemfile
    source :rubygems
    gem 'duality'


### Basic Usage

    :::ruby
    require 'diskcached'
    require 'mongocached' # or memcached if you prefer
    require 'duality'

    $cache = Dulatiy.new(Diskcached.new, Mongocached.new( host: 'remotehost' ))

    # cache something
    $cache.set('cache_key', 'cache_content')

    # get cache
    puts $cache.get('cache_key') # => cache_content

    # delete something
    $cache.delete('cache_key')

    # flush cache
    $cache.flush

### Unimplemented Cache Methods

One thing Duality does for compatability is pass methods via #method_missing. This allows for you to access any method your cache might implement, even if Duality doesn't itself implement it.

It's important to note, though, that the this implementation does not take advantage of the get methods speed increase by returning the faster cache first, but will perform the action in a serialized fashion on one cache, then the other. Additionally, by default, it will return the value of whichever cache works, meaning that if one raises and exception, returns false or nil, but the other returns successfully, it will return the successful result. This is by design.

To force both caches to "be good or die", I've implemented **strict calls**, where by you can prepend "strict_" to any method call which you know Duality doesn't implement and force it to fail if both caches don't return a valid result.

Another thing that's worth mentioning is if either cache raise an exception, it will be caught. If both caches raise an exception, *nil* will be returned. Also, if both caches return *nil*, *nil* will be returned.

##### Example

    :::ruby
    # when only one cache contains requested method

    $cache.one_only_method('cache_key')
    # => returns implementing caches return value

    $cache.strict_one_only_method('cache_key')
    # => raises no method exception

    #
    # when both caches contains requested method

    $cache.both_only_method('cache_key')
    # => returns best match

    $cache.strict_both_only_method('cache_key')
    # => returns best match


### More Info

* [Documentation](http://jmervine.github.io/duality/doc/Duality.html)
* [Coverage](http://jmervine.github.io/duality/coverage/#_AllFiles)
* [Benchmarks](https://github.com/jmervine/duality/blob/master/BENCHMARK.md)
