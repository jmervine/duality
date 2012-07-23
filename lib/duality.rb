class Duality

  VERSION = "0.0.5"
  @@fast, @@slow = nil

  def initialize fast, slow
    # check params are caches
    raise NotACache unless fast.respond_to?(:set) && fast.respond_to?(:get)
    raise NotACache unless slow.respond_to?(:set) && slow.respond_to?(:get)
    @fast = fast
    @slow = slow
  end

  # Set to fast and slow.
  # - return true if both succeed
  # - return false if either fail
  def set key, value
    run_method(:set, key, value)
  end
  alias :save :set

  # Delete from both - async
  def delete key
    run_method(:delete, key)
  end
  alias :remove :delete

  # Flush caches - async
  def flush
    run_method(:flush)
  end
  alias :clean :flush

  def flush_expired
    run_method(:flush_expired)
  end
  alias :cleanup :flush_expired

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

  def run_method meth, *args
    success = true
    begin
      @fast.send(meth, *args) 
    rescue Exception
      success = false 
    rescue 
      success = false 
    end
    begin
      @slow.send(meth, *args) 
    rescue Exception
      success = false 
    rescue 
      success = false 
    end
    return success
  end

  class NotACache < Exception
  end

  class CacheTimeout < Exception
  end
end
