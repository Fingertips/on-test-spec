require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

require 'active_support'
require 'active_support/test_case'

$:.unshift(File.expand_path('../../lib', __FILE__))