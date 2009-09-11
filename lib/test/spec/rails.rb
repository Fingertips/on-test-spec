require 'test/spec'

require 'active_support/test_case'

require 'active_record'
require 'active_record/test_case'

require 'action_controller'
require 'action_controller/test_case'

require 'action_view'
require 'action_view/test_case'

%w(test_spec_ext spec_responder expectations).each { |lib| require "test/spec/rails/#{lib}" }
Dir[File.dirname(__FILE__) + '/rails/**/*_helpers.rb'].each { |lib| require lib }

module Kernel
  alias :context_before_on_test_spec :context
  alias :xcontext_before_on_test_spec :xcontext
  
  # def context(name, superclass=ActiveSupport::TestCase, klass=Test::Spec::TestCase, &block)
  def context(*args, &block)
    name_parts = []
    tests = nil
    
    until args.empty? || (args.first.is_a?(Class) && args.first.ancestors.include?(Test::Unit::TestCase))
      arg = args.shift
      name_parts << arg.to_s
      tests = arg if arg.is_a?(Module)
    end
    
    name = name_parts.join(' ')
    
    superclass = if tests.nil?
      ActiveSupport::TestCase
    elsif tests.ancestors.include?(ActiveRecord::Base)
      ActiveRecord::TestCase
    elsif tests.ancestors.include?(ActionController::Base)
      ActionController::TestCase
    elsif tests.to_s.ends_with?('Helper')
      ActionView::TestCase
    end
    
    klass=Test::Spec::TestCase
    
    spec = context_before_on_test_spec(name, superclass, klass) { self.tests(tests) if respond_to?(:tests) }
    spec.testcase.class_eval(&block)
    spec
  end
  
  def xcontext(name, superclass=ActiveSupport::TestCase, &block)
    xcontext_before_on_test_spec(name, superclass, &block)
  end
  
  private :context, :xcontext
  
  alias :describe :context
  alias :xdescribe :xcontext
end