@1.9
Feature: MiniTest Integration

  As a developer using MiniTest
  I want to define temporary values
  So I can run my tests in isolation

  Scenario: Using temporary values with MiniTest::Unit
  Given I have a file "mini_test_unit.rb" containing:
    """
    require 'minitest/unit'
    require 'minitest/autorun'
    require 'temporaries'

    module Mod
      X = 2
    end

    class MyTest < MiniTest::Unit::TestCase
      use_constant_value Mod, :X, 5

      def test_should_have_x_set_to_5_in_each_test
        assert_equal 5, Mod::X
      end
    end
    """
  When I run "ruby mini_test_unit.rb"
  Then I should see "1 tests, 1 assertions, 0 failures, 0 errors"

  Scenario: Using temporary values with MiniTest::Spec
  Given I have a file "mini_test_spec.rb" containing:
    """
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'temporaries'

    module Mod
      X = 2
    end

    describe Mod do
      use_constant_value Mod, :X, 5

      it "should have x set to 5 in each test" do
        Mod::X.must_equal(5)
      end
    end
    """
  When I run "ruby mini_test_spec.rb"
  Then I should see "1 tests, 1 assertions, 0 failures, 0 errors"
