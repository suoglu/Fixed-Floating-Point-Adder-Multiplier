# 16-bit Adder Multiplier Hardware for Fixed Point and Floating Point Format (binary16)
### Contents of Readme
1. About
 1. Inputs
 2. Outputs
 3. System description
2. Simulation
3. Implementation
4. Extra Notes

---
### About
This project was originated from a laboratory assigment and rewritten with [Xilinx Vivado](http://www.xilinx.com/products/design-tools/vivado.html) to work on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual) FPGA.

* **Inputs:**
  * `Number switches `: Used to enter operands
  * `Reser button (Center button)`: Used to reset system
  * `Operator buttons`: Used select operator, legend follows as:
    * `Up button`: Floating Format Addition
    * `Left button`: Floating Format Multiplication 
    * `Down button`: Fixed Format Addition
    * `Right button`: Fixed Format Multiplication

* **Outputs:**
  * `Overflow LED (Leftmost LED)`: Indicated overflow during operation
  * `State LEDs (Rightmost two LEDs)`: Shows machine state, States follow as:
    1. `IDLE`: System does nothing, waits user
    2. `WAIT1`: System stores operand 1
    3. `WAIT2`: System stores operand 2
    4. `RESULT`: Results is show, operation can be changed for provided numbers
  * `Seven Segment Displays`: Shows operation result in hexadecimal format
 
* **System description:**
  * This project provides a 16 bit adder multiplier hardware and interface for testing designed hardware
  * System works on to number formats:
    * `Fixed Point Format`: Most significant 8 bits represent integer part and Least significant 8 bits represent fraction part.  i.e. IIIIIIIIFFFFFFFF = IIIIIIII.FFFFFFFF
    * `Floating Point Format`: binary16 (IEEE 754-2008) is used. MSB used as sign bit. 10 least significant bits are used as fraction and remaining bits are used as exponent.  i.e. SEEEEEFFFFFFFFFF = (-1)^S \* 1.FFFFFFFFFF \* 2^EEEEE
  * Output is provided in same format as operands

### Simulation
Designed system was successfully simulated using [`operatorCore_sim.v`](https://github.com/suoglu/Fixed-Floating-Point-Adder-Multiplier/blob/master/Simulation/operatorCore_sim.v) file, which is included in the repository. [`operatorCore_sim.v`](https://github.com/suoglu/Fixed-Floating-Point-Adder-Multiplier/blob/master/Simulation/operatorCore_sim.v) file contains 4 test cases. Note that simulation code does not simulate top module, but calculation modules. 
