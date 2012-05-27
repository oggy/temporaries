module Temporaries
  module Adapters
    autoload :Base, 'temporaries/adapters/base'
    autoload :MiniTest, 'temporaries/adapters/mini_test'
    autoload :RSpec, 'temporaries/adapters/rspec'
    autoload :TestUnit, 'temporaries/adapters/test_unit'
  end
end
