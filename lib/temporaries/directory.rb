require 'fileutils'

module Temporaries
  module Directory
    include Core

    def push_temporary_directory(directory)
      exists = File.exist?(directory)
      push_temporary(:directory, [directory, exists])
      FileUtils.mkdir_p directory unless exists
    end

    def pop_temporary_directory
      directory, existed = pop_temporary(:directory)
      FileUtils.rm_rf directory unless existed
    end

    def with_temporary_directory(directory)
      push_temporary_directory(directory)
      begin
        yield
      ensure
        pop_temporary_directory
      end
    end

    def tmp
      top = top_temporary(:directory) and
        top.first
    end
  end
end
