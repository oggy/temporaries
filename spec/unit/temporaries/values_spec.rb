require 'spec/spec_helper'

describe Temporaries::Values do
  before do
    @context_class = Class.new(TestContext) do
      include Temporaries::Values
    end
    @context = @context_class.new
  end

  describe "#push_constant_value and #pop_constant_value" do
    before do
      @mod = Module.new
      @mod.const_set(:CONSTANT, 2)
    end

    it "should set the given module's constant to the pushed value until it is popped" do
      @mod::CONSTANT.should == 2
      @context.push_constant_value @mod, :CONSTANT, 3
      @mod::CONSTANT.should == 3
      @context.pop_constant_value @mod, :CONSTANT
      @mod::CONSTANT.should == 2
    end

    it "should be nestable" do
      @mod::CONSTANT.should == 2
      @context.push_constant_value @mod, :CONSTANT, 3
      @mod::CONSTANT.should == 3
      @context.push_constant_value @mod, :CONSTANT, 5
      @mod::CONSTANT.should == 5
      @context.pop_constant_value @mod, :CONSTANT
      @mod::CONSTANT.should == 3
      @context.pop_constant_value @mod, :CONSTANT
      @mod::CONSTANT.should == 2
    end
  end

  describe "#with_constant_value" do
    before do
      @mod = Module.new
      @mod.const_set(:CONSTANT, 2)
    end

    it "should set the given module's constant to the given value only during the given block" do
      @mod::CONSTANT.should == 2
      block_run = false
      @context.with_constant_value @mod, :CONSTANT, 3 do
        block_run = true
        @mod::CONSTANT.should == 3
      end
      block_run.should be_true
      @mod::CONSTANT.should == 2
    end

    it "should be nestable" do
      @mod::CONSTANT.should == 2
      blocks_run = []
      @context.with_constant_value @mod, :CONSTANT, 3 do
        blocks_run << 1
        @mod::CONSTANT.should == 3
        @context.with_constant_value @mod, :CONSTANT, 5 do
          blocks_run << 2
          @mod::CONSTANT.should == 5
        end
        @mod::CONSTANT.should == 3
      end
      blocks_run.should == [1, 2]
      @mod::CONSTANT.should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @mod::CONSTANT.should == 2
      begin
        @context.with_constant_value @mod, :CONSTANT, 3 do
          @mod::CONSTANT.should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @mod::CONSTANT.should == 2
    end
  end

  describe "#push_attribute_value and #pop_attribute_value" do
    before do
      @klass = Class.new{attr_accessor :attribute}
      @object = @klass.new
      @object.attribute = 2
    end

    it "should set the given object's attribute to the pushed value until it is popped" do
      @object.attribute.should == 2
      @context.push_attribute_value @object, :attribute, 3
      @object.attribute.should == 3
      @context.pop_attribute_value @object, :attribute
      @object.attribute.should == 2
    end

    it "should be nestable" do
      @object.attribute.should == 2
      @context.push_attribute_value @object, :attribute, 3
      @object.attribute.should == 3
      @context.push_attribute_value @object, :attribute, 5
      @object.attribute.should == 5
      @context.pop_attribute_value @object, :attribute
      @object.attribute.should == 3
      @context.pop_attribute_value @object, :attribute
      @object.attribute.should == 2
    end
  end

  describe "#with_attribute_value" do
    before do
      @klass = Class.new{attr_accessor :attribute}
      @object = @klass.new
      @object.attribute = 2
    end

    it "should set the given object's attribute to the given value only during the given block" do
      @object.attribute.should == 2
      block_run = false
      @context.with_attribute_value @object, :attribute, 3 do
        block_run = true
        @object.attribute.should == 3
      end
      block_run.should be_true
      @object.attribute.should == 2
    end

    it "should be nestable" do
      @object.attribute.should == 2
      blocks_run = []
      @context.with_attribute_value @object, :attribute, 3 do
        blocks_run << 1
        @object.attribute.should == 3
        @context.with_attribute_value @object, :attribute, 5 do
          blocks_run << 2
          @object.attribute.should == 5
        end
        @object.attribute.should == 3
      end
      blocks_run.should == [1, 2]
      @object.attribute.should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @object.attribute.should == 2
      begin
        @context.with_attribute_value @object, :attribute, 3 do
          @object.attribute.should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @object.attribute.should == 2
    end
  end

  describe "#push_hash_value and #pop_hash_value" do
    before do
      @hash = {:key => 2}
    end

    it "should set the given hash's key to the pushed value until it is popped" do
      @hash[:key].should == 2
      @context.push_hash_value @hash, :key, 3
      @hash[:key].should == 3
      @context.pop_hash_value @hash, :key
      @hash[:key].should == 2
    end

    it "should be nestable" do
      @hash[:key].should == 2
      @context.push_hash_value @hash, :key, 3
      @hash[:key].should == 3
      @context.push_hash_value @hash, :key, 5
      @hash[:key].should == 5
      @context.pop_hash_value @hash, :key
      @hash[:key].should == 3
      @context.pop_hash_value @hash, :key
      @hash[:key].should == 2
    end
  end

  describe "#with_hash_value" do
    before do
      @hash = {:key => 2}
    end

    it "should set the given hash's key to the given value only during the given block" do
      @hash[:key].should == 2
      block_run = false
      @context.with_hash_value @hash, :key, 3 do
        block_run = true
        @hash[:key].should == 3
      end
      block_run.should be_true
      @hash[:key].should == 2
    end

    it "should be nestable" do
      @hash[:key].should == 2
      blocks_run = []
      @context.with_hash_value @hash, :key, 3 do
        blocks_run << 1
        @hash[:key].should == 3
        @context.with_hash_value @hash, :key, 5 do
          blocks_run << 2
          @hash[:key].should == 5
        end
        @hash[:key].should == 3
      end
      blocks_run.should == [1, 2]
      @hash[:key].should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @hash[:key].should == 2
      begin
        @context.with_hash_value @hash, :key, 3 do
          @hash[:key].should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @hash[:key].should == 2
    end
  end

  describe "#push_instance_variable_value and #pop_instance_variable_value" do
    before do
      @object = Object.new
      @object.instance_eval{@variable = 2}
    end

    it "should set the given object's ivar to the pushed value until it is popped" do
      @object.instance_variable_get(:@variable).should == 2
      @context.push_instance_variable_value @object, :variable, 3
      @object.instance_variable_get(:@variable).should == 3
      @context.pop_instance_variable_value @object, :variable
      @object.instance_variable_get(:@variable).should == 2
    end

    it "should be nestable" do
      @object.instance_variable_get(:@variable).should == 2
      @context.push_instance_variable_value @object, :variable, 3
      @object.instance_variable_get(:@variable).should == 3
      @context.push_instance_variable_value @object, :variable, 5
      @object.instance_variable_get(:@variable).should == 5
      @context.pop_instance_variable_value @object, :variable
      @object.instance_variable_get(:@variable).should == 3
      @context.pop_instance_variable_value @object, :variable
      @object.instance_variable_get(:@variable).should == 2
    end
  end

  describe "#with_instance_variable_value" do
    before do
      @object = Object.new
      @object.instance_eval{@variable = 2}
    end

    it "should set the given object's ivar to the given value only during the given block" do
      @object.instance_variable_get(:@variable).should == 2
      block_run = false
      @context.with_instance_variable_value @object, :variable, 3 do
        block_run = true
        @object.instance_variable_get(:@variable).should == 3
      end
      block_run.should be_true
      @object.instance_variable_get(:@variable).should == 2
    end

    it "should be nestable" do
      @object.instance_variable_get(:@variable).should == 2
      blocks_run = []
      @context.with_instance_variable_value @object, :variable, 3 do
        blocks_run << 1
        @object.instance_variable_get(:@variable).should == 3
        @context.with_instance_variable_value @object, :variable, 5 do
          blocks_run << 2
          @object.instance_variable_get(:@variable).should == 5
        end
        @object.instance_variable_get(:@variable).should == 3
      end
      blocks_run.should == [1, 2]
      @object.instance_variable_get(:@variable).should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @object.instance_variable_get(:@variable).should == 2
      begin
        @context.with_instance_variable_value @object, :variable, 3 do
          @object.instance_variable_get(:@variable).should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @object.instance_variable_get(:@variable).should == 2
    end
  end

  describe "#push_class_variable_value and #pop_class_variable_value" do
    before do
      # Did you know...?
      #
      #  * class C; @@x; end  refers to @@x in C
      #  * C.class_eval '@@x' refers to @@x in C
      #  * C.class_eval{@@x}  refers to @@x in Object
      #  * Class.new{@@x}     refers to @@x in Object
      @class = Class.new
      @class.class_eval '@@variable = 2'
    end

    it "should set the given object's cvar to the pushed value until it is popped" do
      @class.class_eval('@@variable').should == 2
      @context.push_class_variable_value @class, :variable, 3
      @class.class_eval('@@variable').should == 3
      @context.pop_class_variable_value @class, :variable
      @class.class_eval('@@variable').should == 2
    end

    it "should be nestable" do
      @class.class_eval('@@variable').should == 2
      @context.push_class_variable_value @class, :variable, 3
      @class.class_eval('@@variable').should == 3
      @context.push_class_variable_value @class, :variable, 5
      @class.class_eval('@@variable').should == 5
      @context.pop_class_variable_value @class, :variable
      @class.class_eval('@@variable').should == 3
      @context.pop_class_variable_value @class, :variable
      @class.class_eval('@@variable').should == 2
    end
  end

  describe "#with_class_variable_value" do
    before do
      @class = Class.new
      @class.class_eval '@@variable = 2'
    end

    it "should set the given object's cvar to the given value only during the given block" do
      @class.class_eval('@@variable').should == 2
      block_run = false
      @context.with_class_variable_value @class, :variable, 3 do
        block_run = true
        @class.class_eval('@@variable').should == 3
      end
      block_run.should be_true
      @class.class_eval('@@variable').should == 2
    end

    it "should be nestable" do
      @class.class_eval('@@variable').should == 2
      blocks_run = []
      @context.with_class_variable_value @class, :variable, 3 do
        blocks_run << 1
        @class.class_eval('@@variable').should == 3
        @context.with_class_variable_value @class, :variable, 5 do
          blocks_run << 2
          @class.class_eval('@@variable').should == 5
        end
        @class.class_eval('@@variable').should == 3
      end
      blocks_run.should == [1, 2]
      @class.class_eval('@@variable').should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      @class.class_eval('@@variable').should == 2
      begin
        @context.with_class_variable_value @class, :variable, 3 do
          @class.class_eval('@@variable').should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      @class.class_eval('@@variable').should == 2
    end
  end

  describe "#push_global_value and #pop_global_value" do
    before do
      $variable = 2
    end

    after do
      $variable = nil
    end

    it "should set the given global to the pushed value until it is popped" do
      $variable.should == 2
      @context.push_global_value :variable, 3
      $variable.should == 3
      @context.pop_global_value :variable
      $variable.should == 2
    end

    it "should be nestable" do
      $variable.should == 2
      @context.push_global_value :variable, 3
      $variable.should == 3
      @context.push_global_value :variable, 5
      $variable.should == 5
      @context.pop_global_value :variable
      $variable.should == 3
      @context.pop_global_value :variable
      $variable.should == 2
    end
  end

  describe "#with_global_value" do
    before do
      $variable = 2
    end

    it "should set the given global to the given value only during the given block" do
      $variable.should == 2
      block_run = false
      @context.with_global_value :variable, 3 do
        block_run = true
        $variable.should == 3
      end
      block_run.should be_true
      $variable.should == 2
    end

    it "should be nestable" do
      $variable.should == 2
      blocks_run = []
      @context.with_global_value :variable, 3 do
        blocks_run << 1
        $variable.should == 3
        @context.with_global_value :variable, 5 do
          blocks_run << 2
          $variable.should == 5
        end
        $variable.should == 3
      end
      blocks_run.should == [1, 2]
      $variable.should == 2
    end

    it "should handle nonlocal exits" do
      exception_class = Class.new(Exception)
      $variable.should == 2
      begin
        @context.with_global_value :variable, 3 do
          $variable.should == 3
          raise exception_class, 'boom'
        end
      rescue exception_class => e
      end
      $variable.should == 2
    end
  end
end

describe Temporaries::Values do
  describe ".use_constant_value" do
    before do
      @mod = mod = Module.new
      mod.const_set(:CONSTANT, 2)

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_constant_value mod, :CONSTANT, 3
      end
      @context = @context_class.new
    end

    it "should set the given module's constant to the given value for the duration of the run" do
      @mod::CONSTANT.should == 2
      block_run = false
      @context.run do
        block_run = true
        @mod::CONSTANT.should == 3
      end
      block_run.should be_true
      @mod::CONSTANT.should == 2
    end
  end

  describe ".use_attribute_value" do
    before do
      @klass = Class.new{attr_accessor :attribute}
      @object = object = @klass.new
      @object.attribute = 2

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_attribute_value object, :attribute, 3
      end
      @context = @context_class.new
    end

    it "should set the given object's attribute to the given value for the duration of the run" do
      @object.attribute.should == 2
      block_run = false
      @context.run do
        block_run = true
        @object.attribute.should == 3
      end
      block_run.should be_true
      @object.attribute.should == 2
    end
  end

  describe ".use_hash_value" do
    before do
      @hash = hash = {:key => 2}

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_hash_value hash, :key, 3
      end
      @context = @context_class.new
    end

    it "should set the given hash's key to the given value for the duration of the run" do
      @hash[:key].should == 2
      block_run = false
      @context.run do
        block_run = true
        @hash[:key].should == 3
      end
      block_run.should be_true
      @hash[:key].should == 2
    end
  end

  describe ".use_instance_variable_value" do
    before do
      @object = object = Object.new
      @object.instance_eval{@variable = 2}

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_instance_variable_value object, :variable, 3
      end
      @context = @context_class.new
    end

    it "should set the given object's ivar to the given value for the duration of the run" do
      @object.instance_variable_get(:@variable).should == 2
      block_run = false
      @context.run do
        block_run = true
        @object.instance_variable_get(:@variable).should == 3
      end
      block_run.should be_true
      @object.instance_variable_get(:@variable).should == 2
    end
  end

  describe ".use_class_variable_value" do
    before do
      @class = klass = Class.new
      @class.class_eval '@@variable = 2'

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_class_variable_value klass, :variable, 3
      end
      @context = @context_class.new
    end

    it "should set the given object's cvar to the given value for the duration of the run" do
      @class.class_eval('@@variable').should == 2
      block_run = false
      @context.run do
        block_run = true
        @class.class_eval('@@variable').should == 3
      end
      block_run.should be_true
      @class.class_eval('@@variable').should == 2
    end
  end

  describe ".use_global_value" do
    before do
      $variable = 2

      @context_class = Class.new(TestContext) do
        include Temporaries::Values
        use_global_value :variable, 3
      end
      @context = @context_class.new
    end

    after do
      $variable = nil
    end

    it "should set the given global to the given value for the duration of the run" do
      $variable.should == 2
      block_run = false
      @context.run do
        block_run = true
        $variable.should == 3
      end
      block_run.should be_true
      $variable.should == 2
    end
  end
end
