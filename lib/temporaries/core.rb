module Temporaries
  module Core
    protected

    def push_temporary(key, value)
      temporaries[key].push(value)
    end

    def pop_temporary(key)
      temporaries[key].pop
    end

    def top_temporary(key)
      temporaries[key].last
    end

    def temporary_stack_empty?(key)
      temporaries[key].empty?
    end

    def temporaries
      @temporaries ||= Hash.new{|h,k| h[k] = []}
    end
  end
end
