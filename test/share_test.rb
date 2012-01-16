require File.expand_path('../test_helper', __FILE__)
require 'test/spec/share'

class DummyMock
  extend SharedSpecsInclusionHelper
  
  class << self
    attr_reader :times_called
    def it(name, &block)
      @times_called ||= 0
      @times_called += 1
    end
    
    def reset!
      @times_called = nil
    end
  end
end

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
  before do
    DummyMock.reset!
  end
  
  it "should add the shared specs to the global shared modules variable" do
    before = $shared_specs.length
    share("Bar") {}
    $shared_specs.length.should == before + 1
  end
  
  it "should have stored the proc that holds the specs" do
    $shared_specs['Dummy'].should.be.instance_of Proc
  end
  
  it "accepts mixed objects as a description" do
    before = $shared_specs.length
    share(Kernel, "concerning modules", 1) {
      it("works") {}
    }
    $shared_specs.length.should == before + 1
    DummyMock.class_eval do
      shared_specs_for Kernel, "concerning modules", 1
    end
    DummyMock.times_called.should.be 1
  end
end

describe "SharedSpecsInclusionHelper::shared_specs_for" do
  before do
    DummyMock.reset!
  end
  
  it "should have extended Test::Unit::TestCase" do
    Test::Unit::TestCase.should.respond_to :shared_specs_for
  end
  
  it "should return the specified module containing the shared specs" do
    DummyMock.class_eval do
      shared_specs_for 'Dummy'
    end
    DummyMock.times_called.should.be 2
  end
end