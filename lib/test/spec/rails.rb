require 'test/spec'

module Test
  module Spec
    module Rails
      module Assertions
        include ActiveSupport::Testing::Assertions
        include ActionController::TestCase::Assertions
      end
    end
    
    class Should
      include Rails::Assertions
    end
    
    class ShouldNot
      include Rails::Assertions
    end
  end
end

%w(test_spec_ext spec_responder expectations).each { |lib| require "test/spec/rails/#{lib}" }
Dir[File.dirname(__FILE__) + '/rails/**/*_helpers.rb'].each { |lib| require lib }

module Kernel
  alias :context_before_on_test_spec :context
  alias :xcontext_before_on_test_spec :xcontext
  
  def context(name, superclass=ActiveSupport::TestCase, klass=Test::Spec::TestCase, &block)
    context_before_on_test_spec(name, superclass, klass, &block)
  end
  
  def xcontext(name, superclass=ActiveSupport::TestCase, &block)
    xcontext_before_on_test_spec(name, superclass, &block)
  end
  
  private :context, :xcontext
  
  alias :describe :context
  alias :xdescribe :xcontext
end