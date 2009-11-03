module Test
  module Spec
    module Rails
      module Macros
        class Should
          def not_find
            Test::Spec::Rails::Macros::Response::TestGenerator.new(test_case,
              :not_found,
              'Expected to not find a resource'
            )
          end
        end
        
        module Response
          class TestGenerator < Proxy
            attr_accessor :status, :message, :expected

            def initialize(test_case, status, message)
              self.status = status
              self.message = message

              super(test_case)
            end

            def method_missing(verb, action, params={})
              if [:get, :post, :put, :delete, :options].include?(verb.to_sym)
                description = "should not find resource with #{verb.to_s.upcase} on `#{action}'"
                description << " #{params.inspect}" unless params.blank?

                status = self.status
                message = self.message
                
                if defined?(:ActiveRecord)
                  test_case.it description do
                    begin
                      send(verb, action, immediate_values(params))
                      status.should.messaging(message) == status
                    rescue ActiveRecord::RecordNotFound
                      :not_found.should.messaging(message) == status
                    end
                  end
                else
                  test_case.it description do
                    send(verb, action, immediate_values(params))
                    status.should.messaging(message) == status
                  end
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