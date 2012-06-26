module Temporaries
  autoload :Core, 'temporaries/core'
  autoload :Values, 'temporaries/values'
  autoload :Directory, 'temporaries/directory'
  autoload :Adapters, 'temporaries/adapters'
end

if defined?($TEMPORARIES_TEST)
  # Testing this library. Don't install anything.
else
  defined?(RSpec) and
    Temporaries::Adapters::RSpec.install

  defined?(MiniTest::Spec) and
    if (MiniTest::Unit::VERSION.scan(/\d+/).map { |s| s.to_i } <=> [2, 3, 0]) < 0
      raise "Temporaries requires minitest 2.3.0 or higher. If you're using the version shipped with ruby, note that newer versions are available via gems."
    else
      Temporaries::Adapters::MiniTest.install
    end

  defined?(MiniTest::Unit) and
    Temporaries::Adapters::TestUnit.install(MiniTest::Unit)

  defined?(Test::Unit) and
    Temporaries::Adapters::TestUnit.install(Test::Unit)
end
