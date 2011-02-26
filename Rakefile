require 'rake/testtask'
require 'rake/rdoctask'

desc "By default run all tests"
task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'On Test-spec'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name     = "on-test-spec"
    s.homepage = "http://github.com/Fingertips/on-test-spec"
    s.email    = "eloy.de.enige@gmail.com"
    s.authors  = ["Manfred Stienstra", "Eloy Duran", "Cristi Balan"]
    s.summary  = s.description = "Rails plugin to make testing Rails on test/spec easier."
  end
rescue LoadError
end

begin
  require 'jewelry_portfolio/tasks'
  JewelryPortfolio::Tasks.new do |p|
    p.account = 'Fingertips'
  end
rescue LoadError
end
