`timescale 1ns/1ps

module mac_col_tb;
parameter total_cycle = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+3;
parameter pr = 8;

integer qk_file;
integer qk_scan_file;
integer captured_data;
`define NULL 0

integer K[pr-1:0];
integerQ[total_cycle-1:0][pr-1:0];

integer i,j,k,t,p,q,s,u,m;

reg reset = 1;
reg clk = 0;
reg [pr*bw-1:0] q_in;
reg [1:0] inst = 0;
wire [1;0] o_inst;

wire [bw_psum-1:0] out;
reg [bw_psum-1:0] temp5b;
reg [bw_psum+3:0] temp_sum;
reg [bw_psum-1:0] temp16b;

mac_col_new #(.bw(bw), .bw_psum(bw_psum), .pr(pr)) mac_col_instance (
  .reset(reset),
  .clk(clk),
  .q_in(q_in),
  .out(out),
  .i_inst(i_inst),
  .o_inst(o_inst)
);

initial begin
  $dumpfile("mac_col_tb.vcd");
  $dumpfile(0,mac_col_tb);

  $display("Q data rd");
  qk_file = $fopen("qdata.txt", "r");

  
end
endmodule