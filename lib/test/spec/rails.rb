require 'test/spec'

module Test
  module Spec
    class Should
      include ActionController::Assertions
    end
    
    class ShouldNot
      include ActionController::Assertions
    end
    
    module Rails
    end
  end
end

%w(test_spec_ext spec_responder expectations).each { |lib| require "test/spec/rails/#{lib}" }
Dir[File.dirname(__FILE__) + '/rails/**/*_helpers.rb'].each { |lib| require lib }