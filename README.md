# 16-bit Adder Multiplier Hardware for Fixed Point and Floating Point Format (binary16)

## Contents of Readme

1. About
2. Number Formats
3. Modules
4. Simulation
5. Test
6. Status
7. Issues

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-6C488A.svg)](https://gitlab.com/suoglu/Fixed-Floating-Point-Adder-Multiplier)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-3D76C2.svg)](https://github.com/suoglu/Fixed-Floating-Point-Adder-Multiplier)

---

## About

This project was originated from a laboratory assignment and rewritten with [Xilinx Vivado](http://www.xilinx.com/products/design-tools/vivado.html) to work on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual) FPGA. Two adder and two multiplier modules implemented, one working with fixed point numbers, other with floating point (binary16) numbers.

## Number Formats

**Fixed Point Format:**

 Most significant 8 bits represent integer part and least significant 8 bits represent fraction part.  i.e. `IIIIIIIIFFFFFFFF` = `IIIIIIII.FFFFFFFF`

**Floating Point Format:**

 binary16 (IEEE 754-2008) is used. MSB is used as sign bit. 10 least significant bits are used as fraction and remaining bits are used as exponent. Value `x000000000000000` represents 0. i.e. `SEEEEEFFFFFFFFFF` = `(-1)^S \* 1.FFFFFFFFFF \* 2^EEEEE`

## Modules

### Fixed Point Adder

Module `fixed_adder` is a simple 16 bit adder with overflow signal. Overflow signal can also be used as 17th bit of result.

**Ports:**

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| num1 | I | 16 | First operant |
| num2 | I | 16 | Second operant |
| result | O | 16 | Result of the addition |
| overflow | O | 1 | Overflow flag or bit 17 of the result |

I: Input  O: Output

### Fixed Point Multiplier

Module `fixed_multi` multiply two 16 bit fixed point numbers. Multiplication is in 32 bit, thus no precision lost during multiplication process. Result can be obtained either in 32 bit or in 16 bit. 32 bit format is similar to 16 bit format, 16 most significant bits represent integer part and 16 least significant bits represent fraction part. For 16 bit result overflow and precision lost flags implemented.

**Ports:**

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| num1 | I | 16 | First operant |
| num2 | I | 16 | Second operant |
| result | O | 16 | 16 bit result of the multiplication |
| overflow | O | 1 | Overflow flag |
| precisionLost | O | 1 | Precision lost flag |
| result_full | O | 32 | 32 bit result of the multiplication |

I: Input  O: Output

### Floating Point Adder

Module `float_adder` is an adder module that can add two half-precision floating-point format (binary16) numbers.

**Ports:**

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| num1 | I | 16 | First operant |
| num2 | I | 16 | Second operant |
| result | O | 16 | Result of the addition |
| overflow | O | 1 | Overflow flag |
| zero | O | 1 | Zero flag |

I: Input  O: Output

## Simulation

!!!There are some issues, check below!!!

Fixed point modules simulated using [`operatorCore_sim.v`](Simulation/operatorCore_sim.v). [`operatorCore_sim.v`](Simulation/operatorCore_sim.v) file contains four test cases.

Floating point adder module simulated using [`float_add_sim.v`](Simulation/float_add_sim.v). [`float_add_sim.v`](Simulation/float_add_sim.v) contains ten test cases.

## Test

### Inputs

* `Number switches`: Used to enter operands
* `Reset button (Center button)`: Used to reset system
* `Operator buttons`: Used select operator, legend follows as:
  * `Up button`: Floating Format Addition
  * `Left button`: Floating Format Multiplication
  * `Down button`: Fixed Format Addition
  * `Right button`: Fixed Format Multiplication

### Outputs

* `Overflow LED (Leftmost LED)`: Indicated overflow during operation
* `State LEDs (Rightmost two LEDs)`: Shows machine state, States follow as:
  1. `IDLE`: System does nothing, waits for user input
  2. `WAIT1`: System stores operand 1
  3. `WAIT2`: System stores operand 2
  4. `RESULT`: Results are shown, operation can be changed for provided numbers
* `Seven Segment Displays`: Shows operation result in hexadecimal format

### System description

* This project provides a 16 bit adder multiplier hardware and interface for testing designed hardware
* System works on two number formats shown at number formats section
* Output is provided in the same format as operands

## Status

**Simulation:**

* Fixed Point Modules: 9 January 2021, with [Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado/simulator.html).

* Floating Point Adder: 10 January 2021, with [Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado/simulator.html).

## Issues

`float_multi` module does not work properly when the result of multiplication of two fractions is larger than 2.
