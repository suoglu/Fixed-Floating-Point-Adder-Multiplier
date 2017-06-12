// Yigit Suoglu
// This file contains modules for addition and multipication of 16 bit unsigned
// fixed point and signed floating point formated numbers
/*
 * Fixed Point Format:
 *   Most significant 8 bits represent integer part and Least significant 8 bits
 *   represent fraction part
 *   i.e. IIIIIIIIFFFFFFFF = IIIIIIII.FFFFFFFF
 * ----------------------------------------------------------------------------
 * Floating Point Format:
 *   binary16 (IEEE 754-2008) is used. MSB used as sign bit. 10 least significant
 *   bits are used as fraction and remaining bits are used as exponent
 *   i.e. SEEEEEFFFFFFFFFF = (-1)^S * 1.FFFFFFFFFF * 2^EEEEE
 */

//fixed adder adds unsigned fixed numbers. Overflow flag is high in case of overflow
module fixed_adder(num1, num2, result, overflow);
  input [15:0] num1, num2;
  output [15:0] result;
  output overflow;

  //single assign statement handles fixed additon
  assign {overflow, result} = (num1 + num2);

endmodule

//fixed multi multiplies unsigned fixed numbers. Overflow flag is high in case of overflow
module fixed_multi(num1, num2, result, overflow);
  input [15:0] num1, num2; //num1 is multiplicand and num2 is multiplier
  output [15:0] result;
  output overflow;
  reg [22:0] mid [15:0]; //shifted values
  reg [23:0] midB[3:0]; //addition of shifted values
  wire [23:0] preResult; //24-bit results

  assign result = preResult[15:0]; //least significant 16-bit is results
  assign overflow = |preResult[23:16]; // most significant 8-bit is overflow
  assign preResult = midB[0] + midB[1] + midB[2] + midB[3];
  always@* //midB wires are added for readability
    begin
      midB[0] = mid[0] + mid[4] + mid[8] + mid[15];
      midB[1] = mid[1] + mid[5] + mid[9] + mid[14];
      midB[2] = mid[2] + mid[6] + mid[10] + mid[13];
      midB[3] = mid[3] + mid[7] + mid[11] + mid[12];
    end
  always@* //shift and enable control
    begin
      mid[0] = (num1 >> 8) & {16{num2[0]}};
      mid[1] = (num1 >> 7) & {16{num2[1]}};
      mid[2] = (num1 >> 6) & {16{num2[2]}};
      mid[3] = (num1 >> 5) & {16{num2[3]}};
      mid[4] = (num1 >> 4) & {16{num2[4]}};
      mid[5] = (num1 >> 3) & {16{num2[5]}};
      mid[6] = (num1 >> 2) & {16{num2[6]}};
      mid[7] = (num1 >> 1) & {16{num2[7]}};
      mid[8] =  num1 & {16{num2[8]}};
      mid[9] = (num1 << 1) & {16{num2[9]}};
      mid[10] = (num1 << 2) & {16{num2[10]}};
      mid[11] = (num1 << 3) & {16{num2[11]}};
      mid[12] = (num1 << 4) & {16{num2[12]}};
      mid[13] = (num1 << 5) & {16{num2[13]}};
      mid[14] = (num1 << 6) & {16{num2[14]}};
      mid[15] = (num1 << 7) & {16{num2[15]}};
    end

endmodule

//float multi multiplies floating point numbers. Overflow flag is high in case of overflow
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
