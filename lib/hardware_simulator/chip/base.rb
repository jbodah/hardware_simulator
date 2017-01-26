require "hardware_simulator/chip/base"

module HardwareSimulator
  module Chip
    class Base
      def self.call(in_state)
        inst = new
        inst.params.each do |param|
          val =
            case param[:type]
            when :array
              HardwareSimulator::FixedArray.from_a(in_state[param[:name]], param[:size])
            when :bit
              in_state[param[:name]]
            else
              raise
            end
          inst.instance_variable_set("@#{param[:name]}", val)
        end

        inst.process

        out_state = {}
        inst.outputs.each do |output|
          output_val = inst.instance_variable_get("@#{output[:name]}")
          out_state[output[:name]] =
            case output[:type]
            when :array
              HardwareSimulator::FixedArray.from_a(output_val, output[:size])
            when :bit
              output_val
            end
        end

        out_state
      end
    end
  end
end
