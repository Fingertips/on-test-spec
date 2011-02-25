class Test::Spec::Rails::SpecResponder
  attr_accessor :test_case
  def initialize(test_case)
    self.test_case = test_case
  end
end