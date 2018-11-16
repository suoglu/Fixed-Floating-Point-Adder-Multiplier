`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Yigit Suoglu
// 
// Create Date: 07/06/2017 03:21:44 PM
// Design Name: Fixed-Floating-Point-Adder-Multiplier
// Module Name: operatorCore_sim
// Target Devices: Basys 3
// Tool Versions: Vivado 2017.2
// Description: Simulation for all adder subtructor modules in the desing
// 
// Dependencies: adder-mutiplier.v
//////////////////////////////////////////////////////////////////////////////////


module operatorCore_sim();

    reg [15:0] num1, num2;
    wire [15:0] floA, floM, fixA, fixM;
    wire [3:0] overflow;
    
    fixed_adder uut0(num1, num2, fixA, overflow[0]);
    fixed_multi uut1(num1, num2, fixM, overflow[1]);
    float_multi uut2(num1, num2, floM, overflow[2]);
    float_adder uut3(num1, num2, floA, overflow[3]);
    
    initial //test cases here
        begin
            num1 <= 16'd27;
            num2 <= 16'd42;
           #250
            num1 <= 16'd561;
            num2 <= 16'd158;
           #250
           num1 <=  16'b1010101010001110;
           num2 <= 16'b0101011100100110;
           #250
           num1 <= 16'b1111110110111010;
           num2 <= 16'b0100111001001111;
        end   
endmodule
