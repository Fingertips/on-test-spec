require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'active_support'
require 'active_support/testing/assertions'

require File.expand_path('../../lib/test/spec/rails/expectations', __FILE__)

describe "Expectations" do
  it "should know if arrays of records are equal" do
    [].should.equal_records []
    [stub(:id => 1)].should.equal_records [stub(:id => 1)]
    [stub(:id => 1), stub(:id => 2)].should.equal_records [stub(:id => 1), stub(:id => 2)]
    
    [stub(:id => 2)].should.not.equal_records [stub(:id => 1)]
    [stub(:id => 1), stub(:id => 2)].should.not.equal_records [stub(:id => 1)]
    [stub(:id => 1)].should.not.equal_records [stub(:id => 1), stub(:id => 2)]
  end
end