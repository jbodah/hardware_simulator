require "hardware_simulator/chip/base"

module HardwareSimulator
  module Chip
    class Base
      def self.call(in_state)
        inst = new
        inst.params.each do |param|
          inst.instance_variable_set("@#{param}", in_state[param])
        end

        inst.process

        out_state = {}
        inst.outputs.each do |output|
          out_state[output] = inst.instance_variable_get("@#{output}")
        end

        out_state
      end
    end
  end
end
