/* ---------------------------------------------------- *
 * Title       : Floating Point Multiplier Simulation   *
 * Project     : Fixed Floating Point Adder Multiplier  *
 * ---------------------------------------------------- *
 * File        : float_multi_sim.v                      *
 * Author      : Yigit Suoglu                           *
 * Last Edit   : /01/2021                             *
 * ---------------------------------------------------- *
 * Description : Simulation for Floating Point          *
 *               Multiplier                             *
 * ---------------------------------------------------- */

`timescale 1ns / 1ps
// `include "Sources/adder-multiplier.v"

module flpm_sim();
  reg [9:0] fra1, fra2;
  reg sign1, sign2;
  reg [4:0] exp1, exp2;
  wire [15:0] result, num1, num2;
  wire overflow, zero, precisionLost;
  wire [9:0] res_fra;
  wire res_sign, nan;
  wire [4:0] res_exp;

  assign {res_sign, res_exp, res_fra} = result;
  assign num1 = {sign1, exp1, fra1};
  assign num2 = {sign2, exp2, fra2};

  float_multi uut(num1, num2, result, overflow, zero, nan, precisionLost);

  initial
    begin
      //Multipcation with precision lost
      sign1 = 0;
      sign2 = 0;
      exp1 = 21;
      exp2 = 4;
      fra1 = 10'b10100101;
      fra2 = 10'b11001100;
      #100
      //Multipcation without precision lost
      sign1 = 0;
      sign2 = 0;
      exp1 = 4;
      exp2 = 4;
      fra1 = 10'b10100000;
      fra2 = 10'b01100000;
      #100
      //Multipcation without precision lost diffrent signs
      sign1 = 1;
      sign2 = 0;
      exp1 = 16;
      exp2 = 7;
      fra1 = 10'b10110000;
      fra2 = 10'b11000000;
      #100
      //Multipcation with Zero
      sign1 = 0;
      sign2 = 0;
      exp1 = 16;
      exp2 = 0;
      fra1 = 10'b10110000;
      fra2 = 10'b00000000;
      #100
      //Multipcation with Infinite
      sign1 = 0;
      sign2 = 0;
      exp1 = 16;
      exp2 = 5'b11111;
      fra1 = 10'b10110000;
      fra2 = 10'b00000000;
      #100
      //Overflow
      sign1 = 0;
      sign2 = 0;
      exp1 = 16;
      exp2 = 20;
      fra1 = 10'b10110000;
      fra2 = 10'b01011000;
      #100
      //Multipcation of 1 subnormal, 1 normal
      sign1 = 0;
      sign2 = 0;
      exp1 = 0;
      exp2 = 20;
      fra1 = 10'b11100000;
      fra2 = 10'b01100000;
      #100
      //Multipcation of 2 subnormal
      sign1 = 0;
      sign2 = 0;
      exp1 = 0;
      exp2 = 0;
      fra1 = 10'b10111000;
      fra2 = 10'b10000000;
    end
endmodule//module_name