module Test
  module Spec
    module Rails
      module RequestHelpers
        attr_reader :request
      end
    end
  end
end

Test::Unit::TestCase.send(:include, Test::Spec::Rails::RequestHelpers)