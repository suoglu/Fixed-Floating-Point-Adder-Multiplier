module FixedFloatingAddMulti(clk, sw, leds, a, b, c, d, e, f, g, an0, an1, an2, an3);
  input [15:0] sw;
  input FlA, FlM, FiA, FiM; //Fi: fixed, Fl: floating, A: add, M: multiply
  input clk;
  output reg [15:0] leds;
  output a, b, c, d, e, f, g; //SSD cathodes
  output an0, an1, an2, an3; //SSD anodes



endmodule
