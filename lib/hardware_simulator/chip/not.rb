require "hardware_simulator/chip/base"

module HardwareSimulator
  module Chip
    class Not < Base
      def params
        %w(in)
      end

      def outputs
        %w(out)
      end

      def process
        @out =
          case @in
          when 0 then 1
          when 1 then 0
          else
            raise
          end
      end
    end
  end
end
