require "hardware_simulator/version"
require "hardware_simulator/chip"
require "hardware_simulator/chip/nand"
require "hardware_simulator/cmp_file"

module HardwareSimulator
  def self.test(chip, cmp_file)
    require "minitest/autorun"
    require "minitest/pride"
    Class.new(Minitest::Test) do
      HardwareSimulator::CmpFile.load(cmp_file).each do |test|
        define_method "test_#{chip.name}__#{test.expected}" do
          expected_output =
            test.expected.reduce({}) do |acc, (k, v)|
              if chip.new.outputs.include?(k)
                acc[k] = v
              end
              acc
            end

          assert_equal expected_output, chip.call(test.input)
        end
      end
    end
  end

  def self.test_vendor(chip_name)
    chip = HardwareSimulator::Chip.from_file("vendor/#{chip_name}.hdl")
    test(chip, "vendor/#{chip_name}.cmp")
  end
end
