//Yigit Suoglu
//Contains top module of implementation
`timescale 1ns / 1ps

module FixedFloatingAddMulti(clk, rst, sw, leds, FlA_d, FlM_d, FiA_d, FiM_d,
                                  a, b, c, d, e, f, g, an0, an1, an2, an3);
  parameter Floating_Add = 2'b0;
  parameter Floating_Mult = 2'b1;
  parameter Fixed_Add = 2'b10;
  parameter Fixed_Mult = 2'b11;
  input [15:0] sw;
  input FlA_d, FlM_d, FiA_d, FiM_d; //Fi: fixed, Fl: floating, A: add, M: multiply
  input clk, rst;
  output reg [15:0] leds;
  output a, b, c, d, e, f, g; //SSD cathodes
  output an0, an1, an2, an3; //SSD anodes

  wire [15:0] result_flA, result_flM, result_fiA, result_fiM;
  reg [15:0] result, num1, num2;
  reg waiting;
  reg [1:0] op; //MSB for num format LSB for operation
  wire FlA, FlM, FiA, FiM; //Fi: fixed, Fl: floating, A: add, M: multiply (debounced)
  wire commonBTN; //senstive to all buttons (except rst)

  assign commonBTN = FlA | FlM | FiA | FiM;

  //state transactions
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        waiting <= 0;
      else
        waiting <= waiting + commonBTN;
    end

  //result routing
  always@*
    begin
      case (op)
        2'b00: result = result_flA;
        2'b01: result = result_flM;
        2'b10: result = result_fiA;
        2'b11: result = result_fiM;
      endcase
    end

  //logic for getting operation
  always@(posedge clk)
    begin
      if(waiting)
        op <= {(FiA | FiM) ,(FiM | FlM)};
    end


endmodule
