require 'ritual'

task :ci do
  sh 'bundle exec rspec'

  ENV['BUNDLE_GEMFILE'] = 'Gemfile.minitest-2.2.2'
  sh 'bundle exec cucumber --tags=@minitest-2.2.2 features/mini_test_integration.feature'

  ENV['BUNDLE_GEMFILE'] = 'Gemfile.minitest-2.3.0'
  sh 'bundle exec cucumber --tags=@minitest --tags=~@minitest-2.2.2 features/mini_test_integration.feature'

  ENV['BUNDLE_GEMFILE'] = 'Gemfile.minitest-3.0.0'
  sh 'bundle exec cucumber --tags=@minitest --tags=~@minitest-2.2.2 features/mini_test_integration.feature'

  ENV['BUNDLE_GEMFILE'] = 'Gemfile.rspec'
  sh 'bundle exec cucumber features/rspec_integration.feature'
end
