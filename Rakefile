require 'ritual'

task :ci do
  sh 'rspec'

  require 'minitest/unit'
  if (MiniTest::Unit::VERSION.scan(/\d+/).map { |s| s.to_i } <=> [2, 3, 0]) < 0
    sh 'cucumber --tags=@minitest-2.2.2 features/mini_test_integration.feature'
  else
    sh 'cucumber --tags=@minitest --tags=~@minitest-2.2.2 features/mini_test_integration.feature'
  end

  if $:.find { |dir| File.exist?("#{dir}/rspec.rb") }
    sh 'cucumber features/rspec_integration.feature'
  end
end
