# 16-bit Adder Multiplier Hardware for Fixed Point and Floating Point Format (binary16)

## Contents of Readme

1. About
2. Number Formats
3. Modules
4. Simulation
5. Test
6. Helper Script
7. Status
8. Issues

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-6C488A.svg)](https://gitlab.com/suoglu/Fixed-Floating-Point-Adder-Multiplier)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-3D76C2.svg)](https://github.com/suoglu/Fixed-Floating-Point-Adder-Multiplier)

---

## About

This project was originated from a laboratory assignment and rewritten with [Xilinx Vivado](http://www.xilinx.com/products/design-tools/vivado.html) to work on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual) FPGA. Two adder and two multiplier modules implemented, one working with fixed point numbers, other with floating point (binary16) numbers.

## Number Formats

**Fixed Point Format:**

 Most significant 8 bits represent integer part and least significant 8 bits represent fraction part.

 i.e. `IIIIIIIIFFFFFFFF` = `IIIIIIII.FFFFFFFF`

**Floating Point Format:**

 binary16 (IEEE 754-2008) is used. MSB is used as sign bit. 10 least significant bits are used as fraction and remaining bits are used as exponent.

 For `SEEEEEFFFFFFFFFF`:

|   Exponent   | Fraction is 0 | Fraction is not 0 |
| :------: | :----: | :----: |
| `b00000` | 0 | (-1)^S \* 0.FFFFFFFFFF \* 2^(-14) |
| `b00001` to `b11110` | (-1)^S \* 2^(EEEEE-15) | (-1)^S \* 1.FFFFFFFFFF \* 2^(EEEEE-15) |
| `b11111` | Infinity | NaN |

## Modules

**Flags:**

|   Flag   | Description |
| :------: |   ------  |
| overflow | Result does not fit or is infinite |
| zero | Result is zero |
| NaN | One or both of the operands are not a number |
| precisionLost | Result has errors due to precision lost |

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
| NaN | O | 1 | NaN flag |
| precisionLost | O | 1 | Precision lost flag |

I: Input  O: Output

### Floating Point Multiplier

Module `float_multi` is an multiplier module that can multiply two half-precision floating-point format (binary16) numbers. Currently, multiplying a normal and a subnormal value does not work properly.

**Ports:**

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| num1 | I | 16 | First operant |
| num2 | I | 16 | Second operant |
| result | O | 16 | Result of the multiplication |
| overflow | O | 1 | Overflow flag |
| zero | O | 1 | Zero flag |
| NaN | O | 1 | NaN flag |
| precisionLost | O | 1 | Precision lost flag |

I: Input  O: Output

## Simulation

Fixed point modules simulated using [`operatorCore_sim.v`](Simulation/operatorCore_sim.v). It contains four test cases.

Floating point adder module simulated using [`float_add_sim.v`](Simulation/float_add_sim.v). It contains ten test cases.

Floating point multiplier module simulated using [`float_multi_sim.v`](Simulation/float_multi_sim.v).

## Test

### Inputs

* `Number switches`: Used to enter operands
* `Reset/New calculation (Center button)`: Used to reset system or begin new calculation
* `Operator buttons`: Switch operation, legend follows as:
  * `Up button`: Floating Format Addition
  * `Left button`: Floating Format Multiplication
  * `Down button`: Fixed Format Addition
  * `Right button`: Fixed Format Multiplication

### Outputs

* `Overflow LED (Leftmost LED)`: Indicates overflow during operation
* `Zero LED (Second Leftmost LED)`: Indicateds zero result
* `NaN LED (Third Leftmost LED)`: Indicates NaN error
* `precisionLost LED (Forth Leftmost LED)`: Indicates precision lost during operation
* `State LEDs (Rightmost two LEDs)`: Shows machine state, States follow as:
  1. `IDLE`: System does nothing, waits for user input
  2. `WAIT1`: System stores operand 1
  3. `WAIT2`: System stores operand 2
  4. `RESULT`: Results are shown, operation can be changed for provided numbers
* `Seven Segment Displays`: Shows operation result in hexadecimal format

### System description

* This project provides a 16 bit adder multiplier hardware and interface for testing designed hardware
* System works on two number formats shown at number formats section
* Output is provided in the same format as the operands
* Flow:
  * Start with `Reset/New calculation` button.
  * Enter the first operand via `Switches` and press any one of the `Operator buttons`.
  * Enter the second operand via `Switches` and press any one of the `Operator buttons`.
  * System will calculate results for all of the modules. Shown output can be chosen via `Operator buttons`.
  * To initiate a new calculation press `Reset/New calculation` button.

## Helper Scripts

Helper python 3 scripts are added to help verfication. They can be found at [Scripts](Scripts/) directory. Script can be used to calculate operation results for binary16 format or decode 16 bit binary16.

## Status

**Simulation:**

* Fixed Point Modules: 9 January 2021, with [Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado/simulator.html).
* Floating Point Adder: 22 May 2021, with [Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado/simulator.html).
* Floating Point Multiplier: 23 May 2021, with [Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado/simulator.html).

**Test:**

* Fixed Point Modules: 22 May 2021, on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual)
* Floating Point Adder: 22 May 2021, on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual)
* Floating Point Multiplier: 22 May 2021, on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual)

## Issues

* Minor bug in floating multiplier module. Some of the results incorrect. See [issue](https://gitlab.com/suoglu/Fixed-Floating-Point-Adder-Multiplier/-/issues/4) #4.
