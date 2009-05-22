require File.expand_path('../../test_helper', __FILE__)
require 'test/spec/rails/macros'

describe "TestGenerator, concerning generation" do
  before do
    @test = mock('Test')
    @generator = Test::Spec::Rails::Macros::Authorization::TestGenerator.new(@test)
  end
  
  it "should generate a test description for a GET" do
    @test.expects(:it).with("should disallow GET on `index'")
    @generator.get(:index)
  end
  
  it "should generate a test description for a POST with params" do
    @test.expects(:it).with("should disallow POST on `create\' {:venue=>{:name=>\"Bitterzoet\"}}")
    @generator.post(:create, :venue => { :name => "Bitterzoet" })
  end
  
  it "should raise a NoMethodError when you disallow an unknown HTTP verb" do
    lambda {
      @generator.unknown :index
    }.should.raise(NoMethodError)
  end
end

class Immediate
  def self.it(description, &block)
    block.call
  end
end

describe "TestGenerator, concerning test contents" do
  before do
    @generator = Test::Spec::Rails::Macros::Authorization::TestGenerator.new(Immediate)
    @generator.stubs(:access_denied?).returns(true)
  end
  
  it "should send the verb and options to the controller" do
    params = {:venue => {:name => "Bitterzoet"}}
    @generator.stubs(:immediate_values).with(params).returns(params)
    @generator.expects(:send).with(:post, :create, params)
    
    @generator.post(:create, params)
  end
  
  it "should immediate values in params" do
    params = {:name => 'bitterzoet'}
    
    @generator.expects(:immediate_values).with(params).returns(params)
    @generator.stubs(:send)
    
    @generator.post(:create, params)
  end
end

describe "Macros::Authorization" do
  it "should return a test generator when a new disallow rule is invoked" do
    test_case = mock('TestCase')
    proxy = Test::Spec::Rails::Macros::Should.new(test_case)
    
    generator = proxy.disallow
    
    generator.should.is_a(Test::Spec::Rails::Macros::Authorization::TestGenerator)
    generator.test_case.should == test_case
  end
end