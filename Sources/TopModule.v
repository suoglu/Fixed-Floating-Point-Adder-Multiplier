//Yigit Suoglu
//Contains top module of implementation
`timescale 1ns / 1ps

module FixedFloatingAddMulti(clk, rst, sw, leds, FlA_d, FlM_d, FiA_d, FiM_d,
                                  a, b, c, d, e, f, g, an0, an1, an2, an3);
  parameter IDLE = 2'b0, WAIT1 = 2'b1, WAIT2 = 2'b10, RESULT = 2'b11;
  parameter Floating_Add = 2'b0;
  parameter Floating_Mult = 2'b1;
  parameter Fixed_Add = 2'b10;
  parameter Fixed_Mult = 2'b11;
  input [15:0] sw;
  input FlA_d, FlM_d, FiA_d, FiM_d; //Fi: fixed, Fl: floating, A: add, M: multiply
  input clk, rst;
  output [15:0] leds;
  output a, b, c, d, e, f, g; //SSD cathodes
  output an0, an1, an2, an3; //SSD anodes

  wire [6:0] abcdefg1, abcdefg2, abcdefg3, abcdefg0;
  wire [15:0] result_flA, result_flM, result_fiA, result_fiM;
  reg [15:0] result, num1, num2;
  reg [1:0] state;
  reg overflow;
  reg [1:0] op; //MSB for num format LSB for operation
  wire FlA, FlM, FiA, FiM; //Fi: fixed, Fl: floating, A: add, M: multiply (debounced)
  wire commonBTN; //senstive to all buttons (except rst)
  wire of_FlA, of_FlM, of_FiA, of_FiM; //overflow signals for operations
/*
  //Modules Start
  //operators
  fixed_adder fiA(.num1(num1), .num2(num2), .result(result_fiA), .overflow(of_FiA));
  fixed_multi fiM(.num1(num1), .num2(num2), .result(result_fiM), .overflow(of_FiM));
  float_multi flM(.num1(num1), .num2(num2), .result(result_flM), .overflow(of_FlM));
  float_adder flA(.num1(num1), .num2(num2), .result(result_flA), .overflow(of_FlA));

  //seven segment display decoders
  ssdDecode ssd_0(result[3:0], abcdefg0);
  ssdDecode ssd_1(result[7:4], abcdefg1);
  ssdDecode ssd_2(result[11:8], abcdefg2);
  ssdDecode ssd_3(result[15:12], abcdefg3);

  //seven segment display controller
  ssd_cntr ssdController(clk, rst, abcdefg0[6],abcdefg1[6],abcdefg2[6],abcdefg3[6],
  abcdefg0[5],abcdefg1[5],abcdefg2[5],abcdefg3[5],
  abcdefg0[4], abcdefg1[4], abcdefg2[4], abcdefg3[4],
  abcdefg0[3], abcdefg1[3], abcdefg2[3], abcdefg3[3],
  abcdefg0[2], abcdefg1[2], abcdefg2[2], abcdefg3[2],
  abcdefg0[1], abcdefg1[1], abcdefg2[1], abcdefg3[1],
  abcdefg0[0], abcdefg1[0], abcdefg2[0], abcdefg3[0],
  a,b,c,d,e,f,g,an0,an1,an2,an3);
  //Modules End
*/
  assign commonBTN = FlA | FlM | FiA | FiM;
  assign leds[1:0] = state; //least significant two bits of leds show state
  assign leds[15] = overflow; //Most significant bit of leds show overflow

  //state transactions
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        state <= 0;
      else //change state untill RESULT state is reached
        state <= state + (commonBTN & (~(&state)));
    end

  //result and overflow routing
  always@*
    begin
      case (op)
        2'b00:
          begin
            result = result_flA;
            overflow = of_FlA;
          end
        2'b01:
          begin
            result = result_flM;
            overflow = of_FlM;
          end
        2'b10:
          begin
            result = result_fiA;
            overflow = of_FiA;
          end
        2'b11:
          begin
            result = result_fiM;
            overflow = of_FiM;
          end
      endcase
    end

  //logic for getting operation
  always@(posedge clk)
    begin
      if(state[1])
        op <= {(FiA | FiM), (FiM | FlM)};
    end


endmodule
