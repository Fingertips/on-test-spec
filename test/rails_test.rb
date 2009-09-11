require File.expand_path("../test_helper", __FILE__)
require "test/spec/rails"

describe "A test case with a traditional, string only, description" do
  test_case = self
  
  it "should inherit from ActiveSupport::TestCase" do
    test_case.superclass.should.be ActiveSupport::TestCase
  end
  
  it "should have the description given" do
    test_case.name.should ==
      "A test case with a traditional, string only, description"
  end
end

class ActiveRecordModel < ActiveRecord::Base; end
class ActionControllerClass < ActionController::Base; end
module ViewModuleHelper; end

{
  ActiveRecordModel     => ActiveRecord::TestCase,
  ActionControllerClass => ActionController::TestCase,
  ViewModuleHelper      => ActionView::TestCase

}.each do |test_class, expected_test_case|

  describe test_class do
    test_case = self

    it "should inherit from #{expected_test_case}" do
      test_case.superclass.should.be expected_test_case
    end

    it "should use the model class name as the description" do
      test_case.name.should == test_class.to_s
    end
  end

  describe "A test case with prepended description for", test_class do
    test_case = self

    it "should inherit from #{expected_test_case}" do
      test_case.superclass.should.be expected_test_case
    end

    it "should have appended the model class name to the description" do
      test_case.name.should ==
        "A test case with prepended description for #{test_class}"
    end
  end

  describe test_class, "test case with a model class and an appended description" do
    test_case = self

    it "should inherit from #{expected_test_case}" do
      test_case.superclass.should.be expected_test_case
    end

    it "should have prepended the model class name to the description" do
      test_case.name.should ==
        "#{test_class} test case with a model class and an appended description"
    end
  end

  describe "An", test_class, "test case with a model class and a prepended _and_ appended description" do
    test_case = self

    it "should inherit from #{expected_test_case}" do
      test_case.superclass.should.be expected_test_case
    end

    it "should have inserted the model class name in the middle of the description" do
      test_case.name.should ==
        "An #{test_class} test case with a model class and a prepended _and_ appended description"
    end
  end

end