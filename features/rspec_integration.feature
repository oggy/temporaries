Feature: Rspec Integration

  As a developer using RSpec
  I want to define temporary values
  So I can run my tests in isolation

  Scenario: Using temporary values with RSpec
  Given I have a file "rspec.rb" containing:
    """
    require 'temporaries'

    module Mod
      X = 2
    end

    describe Mod do
      use_constant_value Mod, :X, 5

      it "should have X = 5 inside each example" do
        Mod::X.should == 5
      end
    end
    """
  When I run "rspec rspec.rb"
  Then I should see "1 example, 0 failures"
