require File.expand_path('../test_helper', __FILE__)
require 'test/spec/rails'

describe "A test/spec/rails test case" do
  test_case = self
  
  it "should include the ActiveSupport assertions" do
    test_case.ancestors.should.include ActiveSupport::Testing::Assertions
  end
  
  it "should include the ActionController assertions" do
    test_case.ancestors.should.include ActionController::TestCase::Assertions
  end
end