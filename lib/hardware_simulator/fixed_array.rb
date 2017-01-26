module HardwareSimulator
  class FixedArray
    def self.from_a(array, size)
      inst = new(size)
      array.each_with_index do |val, idx|
        inst[idx] = val
      end
      inst
    end

    def initialize(max_size)
      @max_size = max_size
      @array = []
    end

    def respond_to_missing?(sym, incl_priv = false)
      @array.respond_to?(sym)
    end

    def method_missing(sym, *args, &block)
      @array.public_send(sym, *args, &block).tap do
        raise "IndexError" if @array.size > @max_size
      end
    end
  end
end
