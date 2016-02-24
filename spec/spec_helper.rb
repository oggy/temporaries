$TEMPORARIES_TEST = true
require 'temporaries'
require 'support/test_context'

TMP = File.dirname(__FILE__) + '/tmp'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
