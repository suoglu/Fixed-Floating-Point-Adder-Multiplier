// Yigit Suoglu
//This file contains modules about seven segment display
/*
 *   At ssdDecode module output signals in form of abcdefg corresponding:
 *      a
 *    f   b        Note: abcdefg signals should driven low to ilmunate
 *      g                corresponding segment.
 *    e   c
 *      d
 */
`timescale 1ns / 1ps

//Converts 4 bit input to hex abcdefg format provided above
module ssdDecode(in, abcdefg, en);
  parameter zero = 7'b0000001, one = 7'b1001111, two = 7'b0010010;
  parameter thr = 7'b0000110, four = 7'b1001100, five = 7'b0100100;
  parameter six = 7'b0100000, svn = 7'b0001111, eght = 7'b0000000;
  parameter nine = 7'b0000100, A = 7'b0001000, B = 7'b1100000;
  parameter C = 7'b0110001, D = 7'b1000010, E = 7'b0110000, F = 7'b0111000;
  input [3:0] in;
  input en; //enable
  output reg [6:0] abcdefg;

  always@*
    begin
      if(en)
        case (in)
          4'b0: abcdefg = zero;
          4'b1: abcdefg = one;
          4'b10: abcdefg = two;
          4'b11: abcdefg = thr;
          4'b100: abcdefg = four;
          4'b101: abcdefg = five;
          4'b110: abcdefg = six;
          4'b111: abcdefg = svn;
          4'b1000: abcdefg = eght;
          4'b1001: abcdefg = nine;
          4'b1010: abcdefg = A;
          4'b1011: abcdefg = B;
          4'b1100: abcdefg = C;
          4'b1101: abcdefg = D;
          4'b1110: abcdefg = E;
          4'b1111: abcdefg = F;
        endcase
      else
        abcdefg <= 7'b0; 
    end

endmodule // ssdDecode

 // This module controls seven segment display of Basys 3
// This module designed for 100 MHz clock
module ssd_cntr(clk, rst, a0,a1,a2,a3,b0,b1,b2,b3,c0,c1,c2,c3,d0,d1,d2,d3,e0,e1,e2,e3,
f0,f1,f2,f3,g0,g1,g2,g3,a,b,c,d,e,f,g,an0,an1,an2,an3);

  input clk, rst;
  input a0,a1,a2,a3,b0,b1,b2,b3,c0,c1,c2,c3,d0,d1;  // abcdefg signals for
  input f2,f3,g0,g1,g2,g3,d3,e0,e1,e2,e3,f0,f1,d2; // corresponding hex
  output reg a,b,c,d,e,f,g,an0,an1,an2,an3; // connected to ssd interface

  wire stateClk;
  reg [1:0] state;
  reg [15:0] counter; //655.36µs or ~1.526 kHz

  assign stateClk = counter[15]; //state clock determined by MSB of counter

  //Note that: both state and counter will warp 11.. to 00.. at max
  //state transactions
  always@(posedge stateClk or posedge rst)
    begin
      if(rst)
        state <= 2'b0;
      else
        state <= state + 2'b1;
    end

  //counter
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        counter <= 16'b0;
      else
        counter <= state + 16'b1;
    end

  //abcdefg and anode routing
  always@*
    begin
      case (state)
        2'b0:
          begin
            a = a0;
            b = b0;
            c = c0;
            d = d0;
            e = e0;
            f = f0;
            g = g0;
            an0 = 0;
            an1 = 1;
            an2 = 1;
            an3 = 1;
          end
        2'b1:
          begin
            a = a1;
            b = b1;
            c = c1;
            d = d1;
            e = e1;
            f = f1;
            g = g1;
            an0 = 1;
            an1 = 0;
            an2 = 1;
            an3 = 1;
          end
        2'b10:
          begin
            a = a2;
            b = b2;
            c = c2;
            d = d2;
            e = e2;
            f = f2;
            g = g2;
            an0 = 1;
            an1 = 1;
            an2 = 0;
            an3 = 1;
          end
        2'b11:
          begin
            a = a3;
            b = b3;
            c = c3;
            d = d3;
            e = e3;
            f = f3;
            g = g3;
            an0 = 1;
            an1 = 1;
            an2 = 1;
            an3 = 0;
          end

      endcase
    end

endmodule // ssd
