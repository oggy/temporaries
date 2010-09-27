$TEMPORARIES_TEST = true
require 'temporaries'
require 'fileutils'
require 'spec/expectations'

TMP = File.expand_path(File.dirname(__FILE__) + '/../tmp')
LIB = File.expand_path(File.dirname(__FILE__) + '/../../lib')

original_pwd = nil

Before do
  FileUtils.mkdir_p TMP
  original_pwd = Dir.pwd
  Dir.chdir TMP
end

After do
  Dir.chdir original_pwd
  FileUtils.rm_rf TMP
end
