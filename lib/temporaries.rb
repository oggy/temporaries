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
  if RUBY_VERSION >= '1.9.3'
    Temporaries::Adapters::MiniTest.install
  else
    Temporaries::Adapters::TestUnit.install(MiniTest::Unit)
  end
elsif defined?(Test::Unit)
  Temporaries::Adapters::TestUnit.install(Test::Unit)
end
