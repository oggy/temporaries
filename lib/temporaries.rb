module Temporaries
  autoload :Core, 'temporaries/core'
  autoload :Values, 'temporaries/values'
  autoload :Directory, 'temporaries/directory'
  autoload :Adapters, 'temporaries/adapters'
end

if defined?($TEMPORARIES_TEST)
  # Testing this library. Don't install anything.
elsif defined?(RSpec)
  Temporaries::Adapters::RSpec.install
elsif defined?(MiniTest::Unit::TestCase)
  Temporaries::Adapters::MiniTest.install
elsif defined?(Test::Unit)
  Temporaries::Adapters::TestUnit.install
end
