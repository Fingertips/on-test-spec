module Test
  module Spec
    module Rails
      module Helpers
        def self.inspect_records(records)
          "[#{records.map { |record| "#{record.class}[#{record.id}]" }.join(', ')}]"
        end
      end
      
      module ShouldExpectations
        include ActiveSupport::Testing::Assertions
        
        # Test that we were redirected somewhere:
        #   should.redirect
        #
        # Test that we were redirected to a specific url:
        #   should.redirect :controller => 'foo', :action => 'bar'
        # or:
        #   should.redirect_to :controller => 'foo', :action => 'bar', :secure => true
        def redirect(*args)
          if args.empty?
            assert_response @object.response.redirected_to, :redirect
          elsif args.length == 1 and args.first.is_a?(String)
            assert_equal args.first, @object.response.redirected_to
          else
            options = args.extract_options!
            if secure = options.delete(:secure)
              unless secure == true or secure == false
                raise ArgumentError, ":secure option should be a boolean"
              end
            end
            
            @object.instance_eval { assert_redirected_to *args }
            if secure == true
              assert @object.response.redirected_to.starts_with?('https:')
            elsif secure == false
              assert @object.response.redirected_to.starts_with?('http:')
            end
          end
        end
        alias :redirect_to :redirect
        
        # Test that the object is valid
        def validate
          assert_valid @object
        end
        
        # Tests whether the evaluation of the expression changes.
        #
        # lambda { Norm.create }.should.differ('Norm.count')
        # lambda { Norm.create; Norm.create }.should.differ('Norm.count', +2)
        def differ(*args)
          result = nil
          assert_difference(*args) do
            result = @object.call
          end
          result
        end
        alias change differ
        
        # Tests whether certain pages are cached.
        #
        # lambda { get :index }.should.cache_pages(posts_path)
        # lambda { get :show, :id => post }.should.cache_pages(post_path(post), formatted_posts_path(:js, post))
        def cache_pages(*pages, &block)
          if block
            block.call
          else
            @object.call
          end
          cache_dir = ActionController::Base.page_cache_directory
          files = Dir.glob("#{cache_dir}/**/*").map do |filename|
            filename[cache_dir.length..-1]
          end
          assert pages.all? { |page| files.include?(page) }
        end
        
        # Test two HTML strings for equivalency (e.g., identical up to reordering of attributes)
        def dom_equal(expected)
          assert_dom_equal expected, @object
        end
        
        # Tests if the array of records is the same, order may vary
        def equal_records(expected)
          message = "#{Helpers.inspect_records(@object)} does not have the same records as #{Helpers.inspect_records(expected)}"
          
          left = @object.map(&:id).sort
          right = expected.map(&:id).sort
          
          assert(left == right, message)
        end
      end
      
      module ShouldNotExpectations
        include ActiveSupport::Testing::Assertions
        
        # Test that an object is not valid
        def validate
          assert !@object.valid?
        end
        
        # Tests that the evaluation of the expression shouldn't change
        #
        # lambda { Norm.new }.should.not.differ('Norm.count')
        def differ(*args)
          result = nil
          assert_no_difference(*args) do
            result = @object.call
          end
          result
        end
        alias change differ
        
        # Test that two HTML strings are not equivalent
        def dom_equal(expected)
          assert_dom_not_equal expected, @object
        end
        
        # Tests if the array of records is not the same, order may vary
        def equal_records(expected)
          message = "#{Helpers.inspect_records(@object)} has the same records as #{Helpers.inspect_records(expected)}"
          
          left = @object.map(&:id).sort
          right = expected.map(&:id).sort
          
          assert(left != right, message)
        end
      end
    end
  end
end

Test::Spec::Should.send(:include, Test::Spec::Rails::ShouldExpectations)
Test::Spec::ShouldNot.send(:include, Test::Spec::Rails::ShouldNotExpectations)