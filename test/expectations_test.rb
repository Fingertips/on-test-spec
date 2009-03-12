require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'active_support'
require 'active_support/testing/assertions'

require File.expand_path('../../lib/test/spec/rails/expectations', __FILE__)


module TestingAssertionsThemselves
  class << self
    attr_accessor :assertions
  end
  @assertions = []
  
  def assert(*args)
    TestingAssertionsThemselves.assertions << args
  end
  
  def self.last_assertion
    TestingAssertionsThemselves.assertions.last
  end
end

class Test::Spec::Should
  include TestingAssertionsThemselves
end

class Test::Spec::ShouldNot
  include TestingAssertionsThemselves
end

describe "Record expectations" do
  it "should succeed when assertions are correct" do
    [].should.equal_records []
    assertion_was_success
    
    [stub(:id => 1)].should.equal_records [stub(:id => 1)]
    assertion_was_success
    
    [stub(:id => 1), stub(:id => 1)].should.equal_records [stub(:id => 1), stub(:id => 1)]
    assertion_was_success
    
    [stub(:id => 1), stub(:id => 2)].should.equal_records [stub(:id => 1), stub(:id => 2)]
    assertion_was_success
    
    [stub(:id => 2)].should.not.equal_records [stub(:id => 1)]
    assertion_was_success
    
    [stub(:id => 1), stub(:id => 2)].should.not.equal_records [stub(:id => 1)]
    assertion_was_success
    
    [stub(:id => 1)].should.not.equal_records [stub(:id => 1), stub(:id => 2)]
    assertion_was_success
  end
  
  it "should fail when assertions are not corrent" do
    [].should.not.equal_records []
    assertion_was_failure_with_message("[] has the same records as []")
    
    [stub(:id => 1), stub(:id => 1)].should.equal_records [stub(:id => 1)]
    assertion_was_failure_with_message("[Mocha::Mock[1], Mocha::Mock[1]] does not have the same records as [Mocha::Mock[1]]")
    
    [stub(:id => 1), stub(:id => 2)].should.equal_records [stub(:id => 1), stub(:id => 1), stub(:id => 2)]
    assertion_was_failure_with_message("[Mocha::Mock[1], Mocha::Mock[2]] does not have the same records as [Mocha::Mock[1], Mocha::Mock[1], Mocha::Mock[2]]")
    
    [stub(:id => 1), stub(:id => 2), stub(:id => 1)].should.equal_records [stub(:id => 1), stub(:id => 2), stub(:id => 2)]
    assertion_was_failure_with_message("[Mocha::Mock[1], Mocha::Mock[2], Mocha::Mock[1]] does not have the same records as [Mocha::Mock[1], Mocha::Mock[2], Mocha::Mock[2]]")
    
    [stub(:id => 1)].should.not.equal_records [stub(:id => 1)]
    assertion_was_failure_with_message("[Mocha::Mock[1]] has the same records as [Mocha::Mock[1]]")
    
    [stub(:id => 1), stub(:id => 2)].should.not.equal_records [stub(:id => 1), stub(:id => 2)]
    assertion_was_failure_with_message("[Mocha::Mock[1], Mocha::Mock[2]] has the same records as [Mocha::Mock[1], Mocha::Mock[2]]")
    
    [stub(:id => 2)].should.equal_records [stub(:id => 1)]
    assertion_was_failure_with_message("[Mocha::Mock[2]] does not have the same records as [Mocha::Mock[1]]")
    
    [stub(:id => 1), stub(:id => 2)].should.equal_records [stub(:id => 1)]
    assertion_was_failure_with_message("[Mocha::Mock[1], Mocha::Mock[2]] does not have the same records as [Mocha::Mock[1]]")
    
    [stub(:id => 1)].should.equal_records [stub(:id => 1), stub(:id => 2)]
    assertion_was_failure_with_message("[Mocha::Mock[1]] does not have the same records as [Mocha::Mock[1], Mocha::Mock[2]]")
  end
  
  private
  
  def assertion_was_success
    assertion = TestingAssertionsThemselves.last_assertion
    assert assertion.first
  end
  
  def assertion_was_failure_with_message(message)
    assertion = TestingAssertionsThemselves.last_assertion
    assert_equal message, assertion.last
    assert !assertion.first
  end 
end