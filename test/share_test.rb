require 'rubygems' rescue LoadError
require 'test/spec'

require File.expand_path('../../lib/test/spec/share', __FILE__)

class Mock
  class << self
    attr_reader :times_called
    def it(name, &block)
      @times_called ||= 0
      @times_called += 1
    end
  end
end

class DummyTestClass1 < Mock; end
class DummyTestClass2 < Mock; end

share "Dummy" do
  it("spec 1") {}
  it("spec 2") {}
end

describe "Shared specs" do
  it "should define a global variable that will hold all the shared specs" do
    $shared_specs.should.be.instance_of Hash
  end
end

describe "Kernel#share" do
  it "should add the shared specs to the global shared modules variable" do
    before = $shared_specs.length
    share("Bar") {}
    $shared_specs.length.should == before + 1
  end
  
  it "should create a new module to hold the specs" do
    $shared_specs['Dummy'].should.be.instance_of Module
  end
  
  it "should define Module::included(klass) method, which will define the shared specs on a test class once it's included" do
    DummyTestClass1.send(:include, $shared_specs['Dummy'])
    DummyTestClass1.times_called.should.be 2
  end
end

describe "Kernel#shared_specs_for" do
  it "should return the specified module containing the shared specs" do
    DummyTestClass2.class_eval do
      include shared_specs_for('Dummy')
    end
    DummyTestClass2.times_called.should.be 2
  end
end