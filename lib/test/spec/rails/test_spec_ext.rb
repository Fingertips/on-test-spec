class Test::Spec::Should
  alias :_test_spec_equal :equal
  def equal(*args)
    @object.respond_to?(:should_equal) ? @object.should_equal(*args) : _test_spec_equal(*args)
  end

  alias :_test_spec_be :be
  def be(*args)
    @object.respond_to?(:should_equal) ? @object.should_equal(*args) : _test_spec_be(*args)
  end
end

class Test::Spec::ShouldNot
  alias :_test_spec_equal :equal
  def equal(*args)
    @object.respond_to?(:should_not_equal) ? @object.should_not_equal(*args) : _test_spec_equal(*args)
  end

  alias :_test_spec_be :be
  def be(*args)
    @object.respond_to?(:should_not_equal) ? @object.should_not_equal(*args) : _test_spec_be(*args)
  end
end
