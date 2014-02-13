$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'temporaries/version'

Gem::Specification.new do |gem|
  gem.name = 'temporaries'
  gem.version = Temporaries::VERSION
  gem.authors = ["George Ogata"]
  gem.email = ["george.ogata@gmail.com"]
  gem.license       = 'MIT'
  gem.date = Time.now.strftime('%Y-%m-%d')
  gem.summary = "Set temporary values declaratively."
  gem.homepage = 'http://github.com/oggy/temporaries'

  gem.extra_rdoc_files = ['CHANGELOG', 'LICENSE', 'README.markdown']
  gem.files = Dir['lib/**/*', 'CHANGELOG', 'LICENSE', 'Rakefile', 'README.markdown']
  gem.test_files = Dir["spec/**/*.rb", "features/**/*.{feature,rb}"]
  gem.require_path = 'lib'

  gem.specification_version = 3
end
