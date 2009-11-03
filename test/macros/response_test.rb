require File.expand_path('../../test_helper', __FILE__)
require 'test/spec/rails/macros'

describe "Response::TestGenerator, concerning generation" do
  before do
    @test = mock('Test')
    @generator = Test::Spec::Rails::Macros::Response::TestGenerator.new(@test, :not_found, 'Expected to not find a resource')
  end
  
  it "should generate a test description for a GET" do
    @test.expects(:it).with("should not find resource with GET on `index'")
    @generator.get(:index)
  end
  
  it "should generate a test description for a POST with params" do
    @test.expects(:it).with("should not find resource with POST on `create' {:venue=>{:name=>\"Bitterzoet\"}}")
    @generator.post(:create, :venue => { :name => "Bitterzoet" })
  end
  
  it "should raise a NoMethodError when you pass an unknown HTTP verb" do
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

describe "Response::TestGenerator, concerning test contents" do
  before do
    @generator = Test::Spec::Rails::Macros::Response::TestGenerator.new(Immediate, :not_found, 'Expected to not find a resource')
    @generator.stubs(:send).with(:status).returns(:not_found)
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
    @generator.stubs(:send).returns(true)
    
    @generator.post(:create, params)
  end
  
  it "should test the return value of the validation method against the expected method" do
    @generator.expected = false
    params = {:name => 'bitterzoet'}
    
    @generator.expects(:immediate_values).with(params).returns(params)
    @generator.stubs(:send).returns(false)
    
    @generator.post(:create, params)
  end
end

describe "Macros::Response" do
  before do
    @test_case = mock('TestCase')
    @proxy = Test::Spec::Rails::Macros::Should.new(@test_case)
  end
  
  it "should return a test generator when a new not found rule is invoked" do
    generator = @proxy.not_find
    
    generator.should.is_a(Test::Spec::Rails::Macros::Response::TestGenerator)
    generator.test_case.should == @test_case
    generator.status.should == :not_found
    generator.message.should == 'Expected to not find a resource'
  end
end