$TEMPORARIES_TEST = true
require 'temporaries'
require 'fileutils'
require 'spec/expectations'

TMP = File.expand_path(File.dirname(__FILE__) + '/../tmp')
LIB = File.expand_path(File.dirname(__FILE__) + '/../../lib')

Before do
  FileUtils.mkdir_p(TMP)
end

After do
  FileUtils.rm_rf(TMP)
end
