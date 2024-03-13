module sync_1b(clk, in, out);
input in;
input clk;
output out;
reg in1;
reg in2;
assign out = in2;
always @(posedge clk ) begin
    in1 <= in;
    in2 <=  in1;
end
endmodule