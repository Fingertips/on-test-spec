require 'active_support'

module OnTestSpec
  class AddAllowSwitchCalledTwiceError < StandardError
    # By overriding this method, we can provide a sort of default exception message
    def self.exception(message)
      super("Called add_allow_switch(#{message}) twice! Make sure you don't require your test helper twice.")
    end
  end
end

class Class
  def add_allow_switch(method, options={})
    if method_defined?("original_#{method}")
      fail OnTestSpec::AddAllowSwitchCalledTwiceError, "#{method.inspect}, #{options.inspect}"
    end

    default = options[:default] || false

    class_eval do
      cattr_accessor "allow_#{method}"
      self.send("allow_#{method}=", default)
      
      alias_method "original_#{method}", method
      
      eval %{
        def #{method}(*args, &block)
          if allow_#{method}
            original_#{method}(*args, &block)
          else
            raise RuntimeError, "You're trying to call `#{method}' on `#{self}', which you probably don't want in a test."
          end
        end
      }, binding, __FILE__, __LINE__
    end
  end
end

class Module
  def add_allow_switch(method, options={})
    if __metaclass__.method_defined?("original_#{method}")
      fail OnTestSpec::AddAllowSwitchCalledTwiceError, "#{method.inspect}, #{options.inspect}"
    end

    default = options[:default] || false

    mattr_accessor "allow_#{method}"
    send("allow_#{method}=", default)
    
    unless respond_to?(:__metaclass___)
      def __metaclass__
        class << self; self; end
      end
    end
    
    __metaclass__.class_eval do
      alias_method "original_#{method}", method
      
      eval %{
        def #{method}(*args, &block)
          if allow_#{method}
            original_#{method}(*args, &block)
          else
            raise RuntimeError, "You're trying to call `#{method}' on `#{self}', which you probably don't want in a test."
          end
        end
      }, binding, __FILE__, __LINE__
    end
  end  
end
