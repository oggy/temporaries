Feature: Test::Unit Integration

  As a developer using Test::Unit
  I want to define temporary values
  So I can run my tests in isolation

  Scenario: Using temporary values with Test::Unit
  Given I have a file "test_unit.rb" containing:
    """
    require 'test/unit'
    require 'temporaries'

    module Mod
      X = 2
    end

    class MyTest < Test::Unit::TestCase
      use_constant_value Mod, :X, 5

      def test_should_have_x_set_to_5_in_each_test
        assert_equal 5, Mod::X
      end
    end
    """
  When I run "ruby test_unit.rb"
  Then I should see "1 tests, 1 assertions, 0 failures, 0 errors"
