require "hardware_simulator/chip/parser"

module HardwareSimulator
  module Chip
    def self.from_file(file)
      parse File.read(file)
    end

    def self.parse(hdl)
      Chip::Parser.new(hdl).parse
    end
  end
end
