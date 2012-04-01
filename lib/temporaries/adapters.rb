module Temporaries
  module Adapters
    autoload :Base, 'temporaries/adapters/base'
    autoload :RSpec, 'temporaries/adapters/rspec'
    autoload :TestUnit, 'temporaries/adapters/test_unit'
    autoload :MiniTestSpec, 'temporaries/adapters/mini_test_spec'
  end
end
