duality
=======

a simple cache interface to setting and getting from two caches

* sets to both caches
* gets from faster and then fails over to slower

## Usage

        require 'diskcached'
        require 'memcached'
        require 'duality'
        
        $cache = Duality.new(Diskcached.new, Memcached.new("remotehost:11211")) # example caches
        $cache.set('key', "content")
        puts $cache.get('key')
        
## More Info

### [Documentation](http://rubyops.github.com/duality/doc/Duality.html) 
### [Coverage](http://rubyops.github.com/duality/coverage/)


