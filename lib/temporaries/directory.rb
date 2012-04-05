require 'fileutils'

module Temporaries
  module Directory
    include Core

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def use_temporary_directory(directory)
        temporaries_adapter.before do
          push_temporary_directory(directory)
        end

        temporaries_adapter.after do
          pop_temporary_directory
        end
      end
    end

    def push_temporary_directory(directory)
      if temporary_stack_empty?(:directory)
        FileUtils.rm_rf directory
        FileUtils.mkdir_p directory
        push_temporary(:directory, [directory, false])
      else
        exists = File.exist?(directory)
        FileUtils.mkdir_p directory unless exists
        push_temporary(:directory, [directory, exists])
      end
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
