$shared_specs = {}

module Kernel
  # Creates an anonymous module, which when included into a test case will define the specs as passed in.
  #
  #   share "User" do
  #     it "should authenticate" do
  #       "me".should == "me"
  #     end
  #   end
  #   
  #   describe "User, in general" do
  #     include shared_specs_for('User')
  #   end
  #   
  #   describe "User, in another case" do
  #     include shared_specs_for('User')
  #   end
  #
  #   2 tests, 2 assertions, 0 failures, 0 errors
  def share(name, &specs_block)
    m = $shared_specs[name] = Module.new do
      def self.included(klass); klass.class_eval(&@specs_block); end
    end
    m.instance_variable_set(:@specs_block, specs_block)
  end
  
  # Returns the specified anonymous module. See +share+ for an exmaple.
  def shared_specs_for(name)
    $shared_specs[name]
  end
end