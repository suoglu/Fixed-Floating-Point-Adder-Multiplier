/* ---------------------------------------------------- *
 * Title       : FixFlo Adder Multiplier Modules        *
 * Project     : Fixed Floating Point Adder Multiplier  *
 * ---------------------------------------------------- *
 * File        : adder-multiplier.v                      *
 * Author      : Yigit Suoglu                           *
 * Last Edit   : 11/01/2021                               *
 * ---------------------------------------------------- *
 * Description : Modules for addition and multipication *
 *               of 16 bit unsigned fixed point and     *
 *               signed floating point formated numbers *
 * ---------------------------------------------------- */

/*
 * Fixed Point Format:
 *   Most significant 8 bits represent integer part and Least significant 8 bits
 *   represent fraction part
 *   i.e. IIIIIIIIFFFFFFFF = IIIIIIII.FFFFFFFF
 * ----------------------------------------------------------------------------
 * Floating Point Format:
 *   binary16 (IEEE 754-2008) is used. MSB used as sign bit. 10 least significant
 *   bits are used as fraction and remaining bits are used as exponent.
 *   i.e. SEEEEEFFFFFFFFFF = (-1)^S * 1.FFFFFFFFFF * 2^(EEEEE - 15)
 */

`timescale 1ns / 1ps

//fixed adder adds unsigned fixed numbers.
module fixed_adder(num1, num2, result, overflow);
  input [15:0] num1, num2;
  output [15:0] result;
  output overflow;

  //single assign statement handles fixed additon
  assign {overflow, result} = (num1 + num2);
endmodule

//fixed multi multiplies unsigned fixed numbers.
module fixed_multi(num1, num2, result, overflow, precisionLost, result_full);
  input [15:0] num1, num2; //num1 is multiplicand and num2 is multiplier
  output [15:0] result;
  output overflow, precisionLost;
  reg [31:0] mid [15:0]; //shifted values
  reg [31:0] midB[3:0]; //addition of shifted values
  output [31:0] result_full; //32-bit results
  wire [31:0] num1_ext;

  assign num1_ext = {8'd0, num1, 8'd0};
  assign precisionLost = |result_full[7:0];
  assign result = result_full[23:8]; //get rid of extra bits
  assign overflow = |result_full[31:24]; // most significant 8-bit is overflow
  assign result_full = midB[0] + midB[1] + midB[2] + midB[3];
  always@* //midB wires are added for readability
    begin
      midB[0] = mid[0] + mid[4] + mid[8] + mid[15];
      midB[1] = mid[1] + mid[5] + mid[9] + mid[14];
      midB[2] = mid[2] + mid[6] + mid[10] + mid[13];
      midB[3] = mid[3] + mid[7] + mid[11] + mid[12];
    end
  always@* //shift and enable control
    begin
      mid[0]  = (num1_ext >> 8) & {32{num2[0]}};
      mid[1]  = (num1_ext >> 7) & {32{num2[1]}};
      mid[2]  = (num1_ext >> 6) & {32{num2[2]}};
      mid[3]  = (num1_ext >> 5) & {32{num2[3]}};
      mid[4]  = (num1_ext >> 4) & {32{num2[4]}};
      mid[5]  = (num1_ext >> 3) & {32{num2[5]}};
      mid[6]  = (num1_ext >> 2) & {32{num2[6]}};
      mid[7]  = (num1_ext >> 1) & {32{num2[7]}};
      mid[8]  =  num1_ext       & {32{num2[8]}};
      mid[9]  = (num1_ext << 1) & {32{num2[9]}};
      mid[10] = (num1_ext << 2) & {32{num2[10]}};
      mid[11] = (num1_ext << 3) & {32{num2[11]}};
      mid[12] = (num1_ext << 4) & {32{num2[12]}};
      mid[13] = (num1_ext << 5) & {32{num2[13]}};
      mid[14] = (num1_ext << 6) & {32{num2[14]}};
      mid[15] = (num1_ext << 7) & {32{num2[15]}};
    end

endmodule

//float multi multiplier floating point numbers.
//TODO: fix & verfy module
//TODO: multiplication of fractions can increase exponent (e.g. 1.8 * 1.6)
module float_multi(num1, num2, result, overflow);
  input [15:0] num1, num2;
  output [15:0] result;
  output overflow;
  wire sign1, sign2, signr; //hold signs
  wire [4:0] ex1, ex2; //hold exponents
  wire [9:0] fra1, fra2; //hold fractions
  wire [10:0] float1; // true value of fra1 i.e. 1.ffffffffff
  wire [5:0] exSum; //exponent sum
  wire [10:0] float_res; //fraction result
  reg [10:0] mid[9:0], mid2[1:0];

  assign overflow = exSum[5]; //extra digit of final sum exist at overflow
  //decode numbers
  assign {sign1, ex1, fra1} = num1;
  assign {sign2, ex2, fra2} = num2;
  //Same signs give 0 (positive), different signs give 1 (negative)
  assign signr = (sign1 ^ sign2);
  assign exSum = (ex1 + ex2); //exponentials are added
  assign float1 = {1'b1, fra1};
  assign float_res = float1 + mid2[1] + mid2[0]; //add mid2 terms and integer  of num2
  assign result = {signr, exSum[4:0], float_res[9:0]};

  always@* //create mids from fractions
    begin
      mid[0] = (float1 >> 10) & {16{fra2[0]}};
      mid[1] = (float1 >> 9) & {16{fra2[1]}};
      mid[2] = (float1 >> 8) & {16{fra2[2]}};
      mid[3] = (float1 >> 7) & {16{fra2[3]}};
      mid[4] = (float1 >> 6) & {16{fra2[4]}};
      mid[5] = (float1 >> 5) & {16{fra2[5]}};
      mid[6] = (float1 >> 4) & {16{fra2[6]}};
      mid[7] = (float1 >> 3) & {16{fra2[7]}};
      mid[8] = (float1 >> 2) & {16{fra2[8]}};
      mid[9] = (float1 >> 1) & {16{fra2[9]}};
    end

  always@* //create mid2s from mids
    begin
      mid2[1] = mid[0] + mid[1] + mid[2] + mid[3] + mid[4];
      mid2[0] = mid[5] + mid[6] + mid[7] + mid[8] + mid[9];
    end

endmodule

//float multi multiplies floating point numbers.
module float_adder(num1, num2, result, overflow, zero, NaN);
  //Ports
  input [15:0] num1, num2;
  output [15:0] result;
  output overflow; //overflow flag
  output zero; //zero flag
  output NaN; //Not a Number flag
  //Reassing numbers as big and small
  reg [15:0] bigNum, smallNum; //to seperate big and small numbers
  //Decode big and small number
  wire [9:0] big_fra, small_fra; //to hold fraction part
  wire [4:0] big_ex_pre, small_ex_pre;
  wire [4:0] big_ex, small_ex; //to hold exponent part
  wire big_sig, small_sig; //to hold signs
  wire [10:0] big_float, small_float; //to hold as float number with integer
  reg [10:0] sign_small_float, shifted_small_float; //preparing small float
  wire [3:0] ex_diff; //difrence between exponentials
  reg [9:0] sum_shifted; //Shift fraction part of sum
  reg [3:0] shift_am;
  wire neg_exp;

  wire [10:0] sum; //sum of numbers with integer parts
  wire sum_carry;
  wire sameSign;
  wire zeroSmall;
  wire inf_num; //at least on of the operands is inf.
  
  //Flags
  assign zero = (num1[14:0] == num2[14:0]) & (~num1[15] == num2[15]);
  assign overflow = ((&big_ex[4:1] & ~big_ex[0]) & sum_carry & sameSign) | inf_num;
  assign NaN = (&num1[14:10] & |num1[9:0]) | (&num2[14:10] & |num2[9:0]);
  assign inf_num = (&num1[14:10] & ~|num1[9:0]) | (&num2[14:10] & ~|num2[9:0]); //check for infinate number
  //Get result
  assign result[15] = big_sig; //result sign same as big sign
  assign result[14:10] = ((sameSign) ? (big_ex + {4'd0, (~zeroSmall & sum_carry & sameSign)}) : ((neg_exp | (shift_am == 4'd10)) ? 5'd0 : (~shift_am + big_ex + 5'd1))) | {5{overflow}}; //result exponent
  assign result[9:0] = ((zeroSmall) ? big_fra : ((sameSign) ? ((sum_carry) ? sum[10:1] : sum[9:0]) : ((neg_exp) ? 10'd0 : sum_shifted))) & {10{~overflow}};

  //decode numbers
  assign {big_sig, big_ex_pre, big_fra} = bigNum;
  assign {small_sig, small_ex_pre, small_fra} = smallNum;
  assign sameSign = (big_sig == small_sig);
  assign zeroSmall = ~(|small_ex | |small_fra);
  assign big_ex = big_ex_pre + {4'd0, ~|big_ex_pre};
  assign small_ex = small_ex_pre + {4'd0, ~|small_ex_pre};

  //add integer parts
  assign big_float = {|big_ex_pre, big_fra};
  assign small_float = {|small_ex_pre, small_fra};
  assign ex_diff = big_ex - small_ex; //diffrence between exponents
  assign {sum_carry, sum} = sign_small_float + big_float; //add numbers

  //Get shift amount for subtraction
  assign neg_exp = (big_ex < shift_am);
  always@*
    begin
      casex(sum)
        11'b1xxxxxxxxxx:
          begin
            shift_am = 4'd0;
          end
        11'b01xxxxxxxxx:
          begin
            shift_am = 4'd1;
          end
        11'b001xxxxxxxx:
          begin
            shift_am = 4'd2;
          end
        11'b0001xxxxxxx:
          begin
            shift_am = 4'd3;
          end
        11'b00001xxxxxx:
          begin
            shift_am = 4'd4;
          end
        11'b000001xxxxx:
          begin
            shift_am = 4'd5;
          end
        11'b0000001xxxx:
          begin
            shift_am = 4'd6;
          end
        11'b00000001xxx:
          begin
            shift_am = 4'd7;
          end
        11'b000000001xx:
          begin
            shift_am = 4'd8;
          end
        11'b0000000001x:
          begin
            shift_am = 4'd9;
          end
        default:
          begin
            shift_am = 4'd10;
          end
      endcase
      
    end

  //Shift result for sub.
  always@* 
    begin
      case (shift_am)
        4'd0: sum_shifted = sum[9:0];
        4'd1: sum_shifted = (sum[9:0] << 1);
        4'd2: sum_shifted = (sum[9:0] << 2);
        4'd3: sum_shifted = (sum[9:0] << 3);
        4'd4: sum_shifted = (sum[9:0] << 4);
        4'd5: sum_shifted = (sum[9:0] << 5);
        4'd6: sum_shifted = (sum[9:0] << 6);
        4'd7: sum_shifted = (sum[9:0] << 7);
        4'd8: sum_shifted = (sum[9:0] << 8);
        4'd9: sum_shifted = (sum[9:0] << 9);
        default: sum_shifted = (sum[9:0] << 10);
      endcase
    end

  //take small number to exponent of big number
  always@* 
    begin
      case (ex_diff)
        4'd0: shifted_small_float = small_float;
        4'd1: shifted_small_float = (small_float >> 1);
        4'd2: shifted_small_float = (small_float >> 2);
        4'd3: shifted_small_float = (small_float >> 3);
        4'd4: shifted_small_float = (small_float >> 4);
        4'd5: shifted_small_float = (small_float >> 5);
        4'd6: shifted_small_float = (small_float >> 6);
        4'd7: shifted_small_float = (small_float >> 7);
        4'd8: shifted_small_float = (small_float >> 8);
        4'd9: shifted_small_float = (small_float >> 9);
        4'd10: shifted_small_float = (small_float >> 10);
        default: shifted_small_float = 11'b0;
      endcase
    end

  always@* //if signs are diffrent take 2s compliment of small number
    begin
      if(sameSign)
        begin
          sign_small_float = shifted_small_float;
        end
      else
        begin
          sign_small_float = ~shifted_small_float + 11'b1;
        end
    end

  always@* //determine big number
    begin
      if(num2[14:10] > num1[14:10])
        begin
          bigNum = num2;
          smallNum = num1;
        end
      else if(num2[14:10] == num1[14:10])
        begin
          if(num2[9:0] > num1[9:0])
            begin
              bigNum = num2;
              smallNum = num1;
            end
          else
            begin
              bigNum = num1;
              smallNum = num2;
            end
        end
      else
        begin
          bigNum = num1;
          smallNum = num2;
        end
    end
endmodule
