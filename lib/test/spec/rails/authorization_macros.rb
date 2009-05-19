module Test
  module Spec
    module Rails
      module AuthorizationMacros
        class TestGenerator
          def initialize(test)
            @test = test
          end
          
          def method_missing(verb, action, params={})
            description = "should disallow #{verb.to_s.upcase} on `#{action}'"
            description << " #{params.inspect}" unless params.blank?
            
            @test.it description do
              send(verb, action, params)
              should.deny_access
            end
          end
        end
        
        def disallows
          TestGenerator.new(self)
        end
      end
    end
  end
end

Test::Spec::TestCase::ClassMethods.send(:include, Test::Spec::Rails::AuthorizationMacros)