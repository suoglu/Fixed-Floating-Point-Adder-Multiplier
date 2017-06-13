// Yigit Suoglu
/*
 *   At ssdDecode module output signals in form of abcdefg corresponding:
 *      a
 *    f   b        Note: abcdefg signals should driven low to ilmunate
 *      g                corresponding segment.
 *    e   c
 *      d
 */
`timescale 1ns / 1ps

module ssdDecode (in, abcdefg);
  parameter zero = 7'b0000001, one = 7'b1001111, two = 7'b0010010;
  parameter thr = 7'b0000110, four = 7'b1001100, five = 7'b0100100;
  parameter six = 7'b0100000, svn = 7'b0001111, eght = 7'b0000000;
  parameter nine = 7'b0000100, A = 7'b0001000, B = 7'b1100000;
  parameter C = 7'b0110001, D = 7'b1000010, E = 7'b0110000, F = 7'b0111000;
  input [3:0] in;
  output reg [6:0] abcdefg;

  always@*
    begin
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
    end

endmodule // ssdDecode
