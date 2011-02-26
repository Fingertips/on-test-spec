module Test::Spec::Rails
  module RequestHelpers
    attr_reader :request
  end
end

ActionController::TestCase.send(:include, Test::Spec::Rails::RequestHelpers)