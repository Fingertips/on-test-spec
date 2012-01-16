$shared_specs = {}

module SharedSpecsInclusionHelper
  def self.description(*parts)
    parts.map(&:to_s).join(' ')
  end
  
  # Include the specified shared specs in this test case.
  #
  #   share "User" do
  #     it "should authenticate" do
  #       "me".should == "me"
  #     end
  #   end
  #   
  #   describe "User, in general" do
  #     shared_specs_for 'User'
  #   end
  #   
  #   describe "User, in another case" do
  #     shared_specs_for 'User'
  #   end
  #
  #   2 tests, 2 assertions, 0 failures, 0 errors
  def shared_specs_for(*description)
    self.class_eval &$shared_specs[SharedSpecsInclusionHelper.description(*description)]
  end
end

module Kernel
  # Stores the passed in block for inclusion in test cases.
  #
  #   share "User" do
  #     it "should authenticate" do
  #       "me".should == "me"
  #     end
  #   end
  #   
  #   describe "User, in general" do
  #     shared_specs_for 'User'
  #   end
  #   
  #   describe "User, in another case" do
  #     shared_specs_for 'User'
  #   end
  #
  #   2 tests, 2 assertions, 0 failures, 0 errors
  #
  # You can use anything as a description for the shared specs.
  #
  #   share User, "concerning the use of", 1, :email, "symbol" do
  #     it "should process" do
  #     end
  #   end
  #
  #   describe User do
  #     shared_specs_for User, "concerning the use of", 1, :email, "symbol"
  #   end
  #
  def share(*description, &specs_block)
    $shared_specs[SharedSpecsInclusionHelper.description(*description)] = specs_block
  end
end

Test::Unit::TestCase.send(:extend, SharedSpecsInclusionHelper)