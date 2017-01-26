require "hardware_simulator/chip/base"

module HardwareSimulator
  module Chip
    class Or < Base
      def params
        %w(a b)
      end

      def outputs
        %w(out)
      end

      def process
        @out =
          case
          when @a == 1 then 1
          when @b == 1 then 1
          else 0
          end
      end
    end
  end
end
