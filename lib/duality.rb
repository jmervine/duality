require 'timeout'
class Duality

  VERSION = "0.0.2"
  #DEFAULT_TIMEOUT=1
  @@fast, @@slow = nil

  # Used to set cache connection timeout
  # - default is 0.5 seconds
  #attr_accessor :timeout

  def initialize fast, slow
    # check params are caches
    raise NotACache unless fast.respond_to?(:set) && fast.respond_to?(:get)
    raise NotACache unless slow.respond_to?(:set) && slow.respond_to?(:get)
    @fast = fast
    @slow = slow
    Thread.abort_on_exception = true 
  end

  # Return set timeout or use default.
  #def timeout
    #@timeout||DEFAULT_TIMEOUT
  #end

  # Set to fast and slow.
  # - return true if both succeed
  # - return false if either fail
  def set key, value
    fast = Thread.new { @fast.set(key, value) }
    slow = Thread.new { @slow.set(key, value) }
    fast.join(1)
    slow.join(1)
    (fast.status == false && slow.status == false)
  end
  alias :save :set

  # Delete from both - async
  def delete key
    fast = Thread.new { @fast.delete(key) }
    slow = Thread.new { @slow.delete(key) }
    fast.join(1)
    slow.join(1)
    (fast.status == false && slow.status == false)
  end
  alias :remove :delete

  # Flush caches - async
  def flush
    fast = Thread.new { @fast.flush }
    slow = Thread.new { @slow.flush }
    fast.join(1)
    slow.join(1)
    (fast.status == false && slow.status == false)
  end
  alias :clean :flush

  # Get from fast or slow.
  # - returns nil if none are found
  def get key
    content = nil
    begin
      content = @fast.get(key) 
    rescue Exception
    end

    return content unless content.nil?

    begin
      content = @slow.get(key) 
    rescue Exception
    end
    return content
  end
  alias :load :get

  # Add support for other methods from passed caches
  # this adds support only, but no speed gains.
  # - use "strict_" to ensure both caches contain method
  def method_missing(meth, *args, &block)
    if meth =~ /^strict_(.+)$/
      meth = $1
      return run_missing_method(meth, *args, &block) if @fast.respond_to?(meth) && @slow.respond_to?(meth)
    elsif @fast.respond_to?(meth) || @slow.respond_to?(meth)
      return run_missing_method(meth, *args, &block) 
    end
    super
  end

  private
  def run_missing_method meth, *args, &block
      fast = @fast.send(meth, *args, &block) rescue nil
      slow = @slow.send(meth, *args, &block) rescue nil
      return fast if fast == slow
      return slow if fast.nil?
      return fast
  end

  class NotACache < Exception
  end

  class CacheTimeout < Exception
  end
end
