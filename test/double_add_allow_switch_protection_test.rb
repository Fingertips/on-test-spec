require File.expand_path('../test_helper', __FILE__)
require 'test/spec/add_allow_switch'

module DoubleRequireTestModule
  def self.youre_it
    "you're it"
  end
end

class DoubleRequireTestClass
  def youre_it
    "you're it"
  end
end

describe "Calling add_allow_switch twice" do
  it "raises an error when used with a module" do
    DoubleRequireTestModule.add_allow_switch :youre_it, :default => true

    lambda {
      DoubleRequireTestModule.add_allow_switch :youre_it, :default => true
    }.should.raise(OnTestSpec::AddAllowSwitchCalledTwiceError)
  end

  it "raises an error when used with a class" do
    DoubleRequireTestClass.add_allow_switch :youre_it, :default => true

    lambda {
      DoubleRequireTestClass.add_allow_switch :youre_it, :default => true
    }.should.raise(OnTestSpec::AddAllowSwitchCalledTwiceError)
  end
end
