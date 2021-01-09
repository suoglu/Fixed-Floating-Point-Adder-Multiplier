//Yigit Suoglu
//Contains top module of implementation
`timescale 1ns / 1ps

module FixedFloatingAddMulti(clk, rst, sw, leds, btnU, btnL, btnR, btnD,seg, an0, an1, an2, an3);
  parameter IDLE = 2'b0, WAIT1 = 2'b1, WAIT2 = 2'b10, RESULT = 2'b11;
  parameter Floating_Add = 2'b0;
  parameter Floating_Mult = 2'b1;
  parameter Fixed_Add = 2'b10;
  parameter Fixed_Mult = 2'b11;
  input [15:0] sw;
  input btnU, btnL, btnR, btnD;
  wire FlAd, FlMd, FiAd, FiMd; //Fi: fixed, Fl: floating, A: add, M: multiply
  input clk, rst;
  output [15:0] leds;
  wire a, b, c, d, e, f, g; //SSD cathodes
  output [6:0] seg;
  output an0, an1, an2, an3; //SSD anodes

  wire [6:0] abcdefg1, abcdefg2, abcdefg3, abcdefg0;
  wire [15:0] result_flA, result_flM, result_fiA, result_fiM;
  wire [31:0] result_fiM_full;
  reg [15:0] result, num1, num2;
  reg [1:0] state;
  reg overflow;
  reg [1:0] op; //MSB for num format LSB for operation
  wire FlA, FlM, FiA, FiM; //Fi: fixed, Fl: floating, A: add, M: multiply (debounced)
  wire commonBTN; //senstive to all buttons (except rst)
  wire of_FlA, of_FlM, of_FiA, of_FiM; //overflow signals for operations
  wire ssdEnable; //enables decoders
  wire precisionLost_FiM;
  
  assign seg = {g,f,e,d,c,b,a};
  assign FlAd = btnU; //Up ~ Float Add
  assign FlMd = btnL; //Left ~ Float Multi
  assign FiAd = btnD; //Down ~ Fixed Add 
  assign FiMd = btnR; //Right ~ Fixed Multi
  //Modules Start
  //operators
  fixed_adder fiA(.num1(num1), .num2(num2), .result(result_fiA), .overflow(of_FiA));
  fixed_multi fiM(.num1(num1), .num2(num2), .result(result_fiM), .overflow(of_FiM), .precisionLost(precisionLost_FiM), .result_full(result_fiM_full));
  float_multi flM(.num1(num1), .num2(num2), .result(result_flM), .overflow(of_FlM));
  float_adder flA(.num1(num1), .num2(num2), .result(result_flA), .overflow(of_FlA));

  //seven segment display decoders
  ssdDecode ssd_0(result[3:0], abcdefg0, ssdEnable);
  ssdDecode ssd_1(result[7:4], abcdefg1, ssdEnable);
  ssdDecode ssd_2(result[11:8], abcdefg2, ssdEnable);
  ssdDecode ssd_3(result[15:12], abcdefg3, ssdEnable);

  //seven segment display controller
  ssd_cntr ssdController(clk, rst, abcdefg0[6],abcdefg1[6],abcdefg2[6],abcdefg3[6],
  abcdefg0[5],abcdefg1[5],abcdefg2[5],abcdefg3[5],
  abcdefg0[4], abcdefg1[4], abcdefg2[4], abcdefg3[4],
  abcdefg0[3], abcdefg1[3], abcdefg2[3], abcdefg3[3],
  abcdefg0[2], abcdefg1[2], abcdefg2[2], abcdefg3[2],
  abcdefg0[1], abcdefg1[1], abcdefg2[1], abcdefg3[1],
  abcdefg0[0], abcdefg1[0], abcdefg2[0], abcdefg3[0],
  a,b,c,d,e,f,g,an0,an1,an2,an3);

  //debouncers
  debouncer db0(clk, rst, FlAd, FlA);
  debouncer db1(clk, rst, FlMd, FlM);
  debouncer db2(clk, rst, FiAd, FiA);
  debouncer db3(clk, rst, FiMd, FiM);
  //Modules End

  assign ssdEnable = &state; //ssd's enabled when state is RESULT
  assign commonBTN = FlA | FlM | FiA | FiM;
  assign leds[1:0] = state; //least significant two bits of leds show state
  assign leds[14:2] = 0;
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
        Floating_Add:
          begin
            result = result_flA;
            overflow = of_FlA;
          end
        Floating_Mult:
          begin
            result = result_flM;
            overflow = of_FlM;
          end
        Fixed_Add:
          begin
            result = result_fiA;
            overflow = of_FiA;
          end
        Fixed_Mult:
          begin
            result = result_fiM;
            overflow = of_FiM;
          end
      endcase
    end

  //logic for getting operation
  always@(posedge clk)
    begin
      if(state[1] & commonBTN)
        op <= {(FiA | FiM), (FiM | FlM)};
    end

  //get numbers
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          num1 <= 16'b0;
          num2 <= 16'b0;
        end
      else
        case(state)
          WAIT1: num1 <= sw;
          WAIT2: num2 <= sw;
        endcase


    end

endmodule
