module Test::Spec::Rails
  module ControllerHelpers
    attr_reader :controller
  end
end

ActionController::TestCase.send(:include, Test::Spec::Rails::ControllerHelpers)