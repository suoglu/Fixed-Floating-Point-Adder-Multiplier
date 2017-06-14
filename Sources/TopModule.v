//Yigit Suoglu
//Contains top module of implementation
`timescale 1ns / 1ps

module FixedFloatingAddMulti(clk, rst, sw, leds, FlA_d, FlM_d, FiA_d, FiM_d,
                                  a, b, c, d, e, f, g, an0, an1, an2, an3);
  input [15:0] sw;
  input FlA_d, FlM_d, FiA_d, FiM_d; //Fi: fixed, Fl: floating, A: add, M: multiply
  input clk, rst;
  output reg [15:0] leds;
  output a, b, c, d, e, f, g; //SSD cathodes
  output an0, an1, an2, an3; //SSD anodes

  wire FlA, FlM, FiA, FiM; //Fi: fixed, Fl: floating, A: add, M: multiply (debounced)
  wire commonBTN; //senstive to all buttons (except rst)

  assign commonBTN = FlA | FlM | FiA | FiM;



endmodule
