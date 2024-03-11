// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sync_5b(clk, in, out);

input  [4:0]in; 
input  clk;
output [4:0]out;

reg    [4:0]int1; 
reg    [4:0]int2; 

assign out = int2;

always @ (posedge clk) begin
   int1 <= in;
   int2 <= int1;
end

endmodule
