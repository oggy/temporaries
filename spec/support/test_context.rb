#
# Represents a group of tests, such as a subclass of Test::Unit or
# Spec::Example::ExampleGroup.
#
class TestContext
  class << self
    def temporaries_adapter
      @temporaries_adapter ||= Adapter.new(self)
    end

    def before(&block)
      befores << block
    end

    def after(&block)
      afters << block
    end

    def befores
      @befores ||= []
    end

    def afters
      @afters ||= []
    end
  end

  def run
    self.class.befores.each{|proc| instance_eval(&proc)}
    begin
      yield
    ensure
      self.class.afters.each{|proc| instance_eval(&proc)}
    end
  end

  class Adapter < Temporaries::Adapters::Base
    def before(&block)
      context.before(&block)
    end

    def after(&block)
      context.after(&block)
    end
  end
end
