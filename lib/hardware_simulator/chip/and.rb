module HardwareSimulator
  module Chip
    class And < Base
      def params
        %w(a b)
      end

      def outputs
        %w(out)
      end

      def process
        @out =
          case @a
          when 1
            case @b
            when 1 then 1
            when 0 then 0
            else
              raise
            end
          when 0 then 0
          else
            raise
          end
      end
    end
  end
end
