//Yigit Suoglu
//Contains debouncer for buttons

module debouncer(clk, rst, in_n, out_c);
  input clk, rst, in_n;
  output reg out_c;

  reg [2:0] mid;

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          mid <= 3'b0;
          out_c <= 0;
        end
      else
        begin
          mid <= {mid[1:0], in_n};
          out_c <= (~mid[2]) & mid[1];
        end
    end

endmodule // debouncer
