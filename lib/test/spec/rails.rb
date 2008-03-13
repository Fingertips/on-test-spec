require 'test/spec'

module Test
  module Spec
    module Rails
    end
  end
end

Dir[File.dirname(__FILE__) + '/rails/**/*.rb'].each do |file|
  require file
end