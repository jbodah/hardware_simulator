module HardwareSimulator
  module Chip
    class Parser
      def initialize(hdl)
        @hdl = hdl
      end

      def parse
        parsed =
          @hdl.each_line.reduce({fsm: :top}) do |state, line|
            parse_line(state, line)
          end

        raise "Invalid HDL" unless parsed[:fsm] == :top

        cast(parsed)
      end

      def parse_line(state, line)
        case state[:fsm]
        when :top
          case line
          when /CHIP\s+(\w+)\s*{/
            state[:fsm] = :chip_interface
            state[:name] = $1
          when /^\s*$/
            # skip, whitespace"
          when /^\s*\/\//, /^\s*\/?\*/
            # skip, comment
          else
            raise
          end
        when :chip_interface
          case line
          when /IN\s+(.+)\s*;/
            params = $1.split(",").map(&:strip)
            state[:params] =
              params.map do |param|
                case param
                when /(\w+)\[(\d+)\]/
                  {type: :array, name: $1, size: $2}
                else
                  {type: :bit, name: param}
                end
              end
          when /OUT\s+(.+)\s*;/
            outputs = $1.split(",").map(&:strip)
            state[:outputs] =
              outputs.map do |output|
                case output
                when /(\w+)\[(\d+)\]/
                  {type: :array, name: $1, size: $2}
                else
                  {type: :bit, name: output}
                end
              end
          when /PARTS:/
            state[:fsm] = :chip_parts
          when /^\s*$/
            # skip
          else
            raise
          end
        when :chip_parts
          case line
          when /(\w+)\s*\((.+)\);/
            state[:chip_parts] ||= []
            arg_assignments = $2.split(',').map(&:strip)
            chip_args =
              arg_assignments.reduce({}) do |acc, arg_assignment|
                key, val = arg_assignment.split('=')
                acc[key] = val
                acc
              end
            state[:chip_parts] << [$1, chip_args]
          when /}/
            state[:fsm] = :top
          else
            raise
          end
        else
          raise
        end
        state
      end

      def cast(chip)
        klass = Class.new(Chip::Base).class_eval do
          define_method(:params) do
            chip[:params]
          end

          define_method(:outputs) do
            chip[:outputs]
          end

          define_method(:process) do
            chip[:chip_parts].each do |(part_name, part_args)|
              in_state = part_args.reduce({}) do |acc, (key, val)|
                acc[key] = instance_variable_get("@#{val}")
                acc
              end

              mod = Chip.const_get(part_name)
              out_state = mod.call(in_state)

              out_state.each do |key, val|
                maps_to = part_args[key]
                instance_variable_set("@#{maps_to}", val)
              end
            end
          end

          self
        end

        Chip.const_set(chip[:name], klass)
      end
    end
  end
end
