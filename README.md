duality
=======

a simple cache interface to setting and getting from two caches

* sets to both caches asynchronously
* gets from faster and then fails over to slower

## Usage

        require 'diskcached'
        require 'memcached'
        require 'duality'
        
        $cache = Duality.new(Diskcached.new, Memcached.new) # example caches
        $cache.set('key', "content")
        puts $cache.get('key')
        
## More Info

### [Documentation](http://rubyops.github.com/diskcached/doc/) 
### [Coverage](http://rubyops.github.com/diskcached/coverage/)


