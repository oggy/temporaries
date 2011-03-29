$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'temporaries/version'

Gem::Specification.new do |s|
  s.name = 'temporaries'
  s.version = Temporaries::VERSION
  s.authors = ["George Ogata"]
  s.email = ["george.ogata@gmail.com"]
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = "Set temporary values declaratively."
  s.homepage = 'http://github.com/oggy/temporaries'

  s.extra_rdoc_files = ['CHANGELOG', 'LICENSE', 'README.markdown']
  s.files = Dir['lib/**/*', 'CHANGELOG', 'LICENSE', 'Rakefile', 'README.markdown']
  s.test_files = Dir["spec/**/*.rb", "features/**/*.{feature,rb}"]
  s.require_path = 'lib'

  s.specification_version = 3
  s.add_development_dependency 'ritual', '0.3.0'
  s.add_development_dependency 'rspec', '2.5.0'
  s.add_development_dependency 'cucumber', '0.10.2'
end
