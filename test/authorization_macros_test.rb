require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'active_support'
require 'active_support/test_case'

require File.expand_path('../../lib/test/spec/rails/authorization_macros', __FILE__)

describe "TestGenerator, concerning generation" do
  before do
    @test = mock('Test')
    @generator = Test::Spec::Rails::AuthorizationMacros::TestGenerator.new(@test)
  end
  
  it "should generate a test description for a GET" do
    @test.expects(:it).with("should disallow GET on `index'")
    @generator.get(:index)
  end
  
  it "should generate a test description for a POST with params" do
    @test.expects(:it).with("should disallow POST on `create\' {:venue=>{:name=>\"Bitterzoet\"}}")
    @generator.post(:create, :venue => { :name => "Bitterzoet" })
  end
end

class Immediate
  def self.it(description, &block)
    block.call
  end
end

describe "TestGenerator, concerning test contents" do
  before do
    @generator = Test::Spec::Rails::AuthorizationMacros::TestGenerator.new(Immediate)
  end
  
  it "should send the verb and options to the controller" do
    params = {:venue => { :name => "Bitterzoet" }}
    
    @generator.expects(:send).with(:post, :create, params)
    @generator.expects(:should).returns(mock(:deny_access))
    
    @generator.post(:create, params)
  end
end

describe "AuthorizationMacros" do
  include Test::Spec::Rails::AuthorizationMacros
  
  it "should return a test generator when a new disallow rule is invoked" do
    generator = disallows
    generator.should.is_a(Test::Spec::Rails::AuthorizationMacros::TestGenerator)
  end
end