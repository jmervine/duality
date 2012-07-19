require 'spec_helper'

describe Duality do

  describe "initialize" do
    it "should not initialize without params" do
      expect { Duality.new }.to raise_error
    end
    it "should not initize with params which are not caches" do
      expect { Duality.new(Object.new, Object.new) }.to raise_error
    end
    it "should initize with params which are caches" do
      expect { Duality.new(Diskcached.new, Mongocached.new) }.to_not raise_error
    end
  end

  describe "#set" do
    before(:all) do
      @cache = Duality.new($fast, $slow)
    end
    it "should set to both" do
      expect { @cache.set("test1", "foo") }.to_not raise_error
      $fast.get("test1").should eq "foo"
      $slow.get("test1").should eq "foo"
    end
  end

  describe "#get" do
    before(:all) do
      @cache = Duality.new($fast, $slow)
      $fast.set("fast_test", "bar")
      $slow.set("slow_test", "boo")
    end
    it "should get" do
      @cache.get("test1").should eq "foo"
    end
    it "should get from faster cache when present" do
      @cache.get("fast_test").should eq "bar"
    end
    it "should get from slower cache when not in faster cache" do
      @cache.get("slow_test").should eq "boo"
    end
  end

  describe "#method_missing" do
    before(:all) do
      @cache = Duality.new($fast, $slow)
      @cache.set("test", "foo")
      $fast.set("fast_test", "bar")
      $slow.set("slow_test", "boo")
    end
    it "should use method from cache that supports" do
      @cache.expired?("test").should be_false
    end
  end
  
  describe "#method_missing", "with strict" do
    before(:all) do
      @cache = Duality.new($fast, $slow)
      @cache.set("test", "foo")
      $fast.set("fast_test", "bar")
      $slow.set("slow_test", "boo")
    end
    it "should raise error if both don't support it" do
      expect { @cache.strict_expired?("test") }.to raise_error
    end
  end
  
end

