# HardwareSimulator

a hardware simulator for writing HDL compliant with the free [nand2tetris class](http://www.nand2tetris.org/)

## Motivation

I had a lot of trouble with the Java client provided by the class so I decided to write my own hardware simulator in Ruby.
Ruby is great for metaprogramming and allows us to easily build a library of chips from HDL

## Usage

```rb
# Load the lib
$: << "lib"
require "hardware_simulator"

# Create a chip from HDL
hdl = <<HDL
CHIP Xor {
  IN a, b;
  OUT out;

  PARTS:
  Not (in=a, out=nota);
  Not (in=b, out=notb);
  And (a=a, b=notb, out=x);
  And (a=nota, b=b, out=y);
  Or (a=x, b=y, out=out);
}
HDL

Xor = HardwareSimulator::Chip.parse(hdl)

# Test it
puts Xor.call("a" => 1, "b" => 1)["out"] == 0
puts Xor.call("a" => 1, "b" => 0)["out"] == 1
puts Xor.call("a" => 0, "b" => 1)["out"] == 1
puts Xor.call("a" => 0, "b" => 0)["out"] == 0

# Use and test vendored chips
HardwareSimulator.test_vendor("Xor")
```
