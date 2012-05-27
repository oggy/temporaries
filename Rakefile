require 'ritual'

task :ci do
  if RUBY_VERSION >= '1.9'
    sh 'bundle exec rspec spec && bundle exec cucumber'
  else
    sh 'bundle exec rspec spec && bundle exec cucumber --tags=~@1.9'
  end
end
