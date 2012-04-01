Feature: MiniTest::Spec Integration

  As a developer using MiniTest::Spec
  I want to define temporary values
  So I can run my tests in isolation

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

      it "should have X = 5 inside each example" do
        Mod::X.must_equal 5
      end
    end
    """
  When I run "ruby mini_test_spec.rb"
  Then I should see "1 tests, 1 assertions, 0 failures, 0 errors, 0 skips"
