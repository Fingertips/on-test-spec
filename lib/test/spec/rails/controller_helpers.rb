module Test
  module Spec
    module Rails
      module Controller
        module ClassMethods
          # Sets up the test environment before every functional test
          def tests(controller_class)
            setups << lambda { setup_request_environment(controller_class) }
          end
        end
        module InstanceMethods
          # Sets up the test environment for functional tests
          def setup_request_environment(controller_class)
            controller_class.class_eval do
              def rescue_action(e)
                raise e
              end
            end
            @controller = controller_class.new
            @request    = TestRequest.new
            @response   = TestResponse.new
          end
        end
      end
    end
  end
end

Test::Spec::TestCase::ClassMethods.send(:include, Test::Spec::Rails::Controller::ClassMethods)
Test::Unit::TestCase.send(:include, Test::Spec::Rails::Controller::InstanceMethods)
