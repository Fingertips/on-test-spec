require 'action_controller/test_case'

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
          include ActionController::TestProcess
          include ActionController::TestCase::Assertions
          
          attr_reader :controller
          
          # Sets up the test environment for functional tests
          def setup_request_environment(controller_class)
            controller_class.class_eval do
              def rescue_action(e)
                raise e
              end
            end
            @controller = controller_class.new
            @controller.request = @request = ActionController::TestRequest.new
            @response = ActionController::TestResponse.new
            
            @controller.params = {}
            @controller.send(:initialize_current_url)
          end
        end
      end
    end
  end
end

ActiveSupport::TestCase.send(:extend, Test::Spec::Rails::Controller::ClassMethods)
ActiveSupport::TestCase.send(:include, Test::Spec::Rails::Controller::InstanceMethods)