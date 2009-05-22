module Test
  module Spec
    module Rails
      module Macros
        class Should
          # Generates tests which test authorization code. It assumes a method called <code>access_denied?</code>
          # on the test case.
          #
          # Example:
          #   should.disallow.get :index
          def disallow
            Test::Spec::Rails::Macros::Authorization::TestGenerator.new(test_case)
          end
        end
        
        module Authorization
          class TestGenerator < Proxy
            def method_missing(verb, action, params={})
              if [:get, :post, :put, :delete, :options].include?(verb)
                description = "should disallow #{verb.to_s.upcase} on `#{action}'"
                description << " #{params.inspect}" unless params.blank?
                
                test_case.it description do
                  send(verb, action, immediate_values(params))
                  access_denied?.should == true
                end
              else
                super
              end
            end
          end
        end
      end
    end
  end
end