// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp_row (clk, sfp_inst, fifo_ext_rd, sum_in, sum_out, sfp_in, sfp_out, clk_ext_core, reset, wr_sum, ififo_wr);

  parameter col = 8;
  parameter bw = 8;
  parameter bw_psum = 2*bw+3;

  input  clk, fifo_ext_rd, clk_ext_core, reset;
  input  [bw_psum+3:0] sum_in;
  input [1:0] sfp_inst; 
  input  [col*bw_psum-1:0] sfp_in;
  input wr_sum;
  input ififo_wr;
  wire  [col*bw_psum-1:0] abs;
    wire  [col*bw_psum-1:0] abs_1;
  reg    div_q;
  output [col*bw_psum-1:0] sfp_out;
  output [bw_psum+3:0] sum_out;
  wire [bw_psum+3:0] sum_this_core;

  reg [col*bw_psum-1:0] sfp_in_reg;

  wire signed [bw_psum-1:0] sum_2core;
  wire signed [bw_psum-1:0] sfp_in_sign0;
  wire signed [bw_psum-1:0] sfp_in_sign1;
  wire signed [bw_psum-1:0] sfp_in_sign2;
  wire signed [bw_psum-1:0] sfp_in_sign3;
  wire signed [bw_psum-1:0] sfp_in_sign4;
  wire signed [bw_psum-1:0] sfp_in_sign5;
  wire signed [bw_psum-1:0] sfp_in_sign6;
  wire signed [bw_psum-1:0] sfp_in_sign7;


  reg signed [bw_psum-1:0] sfp_out_sign0;
  reg signed [bw_psum-1:0] sfp_out_sign1;
  reg signed [bw_psum-1:0] sfp_out_sign2;
  reg signed [bw_psum-1:0] sfp_out_sign3;
  reg signed [bw_psum-1:0] sfp_out_sign4;
  reg signed [bw_psum-1:0] sfp_out_sign5;
  reg signed [bw_psum-1:0] sfp_out_sign6;
  reg signed [bw_psum-1:0] sfp_out_sign7;
  wire [col*bw_psum-1:0] sfp_in_sign;
  reg [bw_psum+3:0] sum_q;
  wire [bw_psum+3:0] sum_other_core;
  reg fifo_wr;
  wire acc, div;
  reg acc_q;
  assign acc =sfp_inst[0];
  assign div = sfp_inst[1];
  assign data_ready = div_q && fifo_ext_rd;
  assign sfp_in_sign0 =  abs_1[bw_psum*1-1 : bw_psum*0];
  assign sfp_in_sign1 =  abs_1[bw_psum*2-1 : bw_psum*1];
  assign sfp_in_sign2 =  abs_1[bw_psum*3-1 : bw_psum*2];
  assign sfp_in_sign3 =  abs_1[bw_psum*4-1 : bw_psum*3];
  assign sfp_in_sign4 =  abs_1[bw_psum*5-1 : bw_psum*4];
  assign sfp_in_sign5 =  abs_1[bw_psum*6-1 : bw_psum*5];
  assign sfp_in_sign6 =  abs_1[bw_psum*7-1 : bw_psum*6];
  assign sfp_in_sign7 =  abs_1[bw_psum*8-1 : bw_psum*7];


  assign sfp_out[bw_psum*1-1 : bw_psum*0] = sfp_out_sign0;
  assign sfp_out[bw_psum*2-1 : bw_psum*1] = sfp_out_sign1;
  assign sfp_out[bw_psum*3-1 : bw_psum*2] = sfp_out_sign2;
  assign sfp_out[bw_psum*4-1 : bw_psum*3] = sfp_out_sign3;
  assign sfp_out[bw_psum*5-1 : bw_psum*4] = sfp_out_sign4;
  assign sfp_out[bw_psum*6-1 : bw_psum*5] = sfp_out_sign5;
  assign sfp_out[bw_psum*7-1 : bw_psum*6] = sfp_out_sign6;
  assign sfp_out[bw_psum*8-1 : bw_psum*7] = sfp_out_sign7;


  assign sum_2core = sum_this_core[bw_psum+3:7] + sum_other_core[bw_psum+3:7];

  assign abs_1[bw_psum*1-1 : bw_psum*0] = (sfp_in_sign[bw_psum*1-1]) ?  (~sfp_in_sign[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in_sign[bw_psum*1-1 : bw_psum*0];
  assign abs_1[bw_psum*2-1 : bw_psum*1] = (sfp_in_sign[bw_psum*2-1]) ?  (~sfp_in_sign[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in_sign[bw_psum*2-1 : bw_psum*1];
  assign abs_1[bw_psum*3-1 : bw_psum*2] = (sfp_in_sign[bw_psum*3-1]) ?  (~sfp_in_sign[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in_sign[bw_psum*3-1 : bw_psum*2];
  assign abs_1[bw_psum*4-1 : bw_psum*3] = (sfp_in_sign[bw_psum*4-1]) ?  (~sfp_in_sign[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in_sign[bw_psum*4-1 : bw_psum*3];
  assign abs_1[bw_psum*5-1 : bw_psum*4] = (sfp_in_sign[bw_psum*5-1]) ?  (~sfp_in_sign[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in_sign[bw_psum*5-1 : bw_psum*4];
  assign abs_1[bw_psum*6-1 : bw_psum*5] = (sfp_in_sign[bw_psum*6-1]) ?  (~sfp_in_sign[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in_sign[bw_psum*6-1 : bw_psum*5];
  assign abs_1[bw_psum*7-1 : bw_psum*6] = (sfp_in_sign[bw_psum*7-1]) ?  (~sfp_in_sign[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in_sign[bw_psum*7-1 : bw_psum*6];
  assign abs_1[bw_psum*8-1 : bw_psum*7] = (sfp_in_sign[bw_psum*8-1]) ?  (~sfp_in_sign[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in_sign[bw_psum*8-1 : bw_psum*7];

  assign abs[bw_psum*1-1 : bw_psum*0] = (sfp_in_reg[bw_psum*1-1]) ?  (~sfp_in_reg[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in_reg[bw_psum*1-1 : bw_psum*0];
  assign abs[bw_psum*2-1 : bw_psum*1] = (sfp_in_reg[bw_psum*2-1]) ?  (~sfp_in_reg[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in_reg[bw_psum*2-1 : bw_psum*1];
  assign abs[bw_psum*3-1 : bw_psum*2] = (sfp_in_reg[bw_psum*3-1]) ?  (~sfp_in_reg[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in_reg[bw_psum*3-1 : bw_psum*2];
  assign abs[bw_psum*4-1 : bw_psum*3] = (sfp_in_reg[bw_psum*4-1]) ?  (~sfp_in_reg[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in_reg[bw_psum*4-1 : bw_psum*3];
  assign abs[bw_psum*5-1 : bw_psum*4] = (sfp_in_reg[bw_psum*5-1]) ?  (~sfp_in_reg[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in_reg[bw_psum*5-1 : bw_psum*4];
  assign abs[bw_psum*6-1 : bw_psum*5] = (sfp_in_reg[bw_psum*6-1]) ?  (~sfp_in_reg[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in_reg[bw_psum*6-1 : bw_psum*5];
  assign abs[bw_psum*7-1 : bw_psum*6] = (sfp_in_reg[bw_psum*7-1]) ?  (~sfp_in_reg[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in_reg[bw_psum*7-1 : bw_psum*6];
  assign abs[bw_psum*8-1 : bw_psum*7] = (sfp_in_reg[bw_psum*8-1]) ?  (~sfp_in_reg[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in_reg[bw_psum*8-1 : bw_psum*7];
  


  wire [bw_psum:0] sum0_0, sum0_1, sum0_2, sum0_3;
  assign sum0_0 = abs[bw_psum-1:0] + abs[bw_psum*2-1:bw_psum];
  assign sum0_1 = abs[bw_psum*4-1:bw_psum*3] + abs[bw_psum*3-1:bw_psum*2];
  assign sum0_2 = abs[bw_psum*6-1:bw_psum*5] + abs[bw_psum*5-1:bw_psum*4];
  assign sum0_3 = abs[bw_psum*8-1:bw_psum*7] + abs[bw_psum*7-1:bw_psum*6];
  reg [bw_psum:0] sum0_0_q, sum0_1_q, sum0_2_q, sum0_3_q;

  wire [bw_psum+1:0] sum1_0, sum1_1;
  assign sum1_0 = sum0_0_q + sum0_1_q;
  assign sum1_1 = sum0_2_q + sum0_3_q;
  wire [bw_psum+3:0] sum2;
  assign sum2 = {1'b0, sum1_0} + {1'b0, sum1_1};
  reg [1:0] cnt;
  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_int (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_this_core), 
     .rd(div_q), 
     .wr(fifo_wr), 
     .reset(reset)
  );

//  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_ext (
//     .rd_clk(clk), 
//     .wr_clk(clk), 
//     .in(sum_q),
//     .out(sum_out), 
//     .rd(fifo_ext_rd), 
//     .wr(fifo_wr), 
//     .reset(reset)
//  );
wire fifo_empty, fifo_full;

fifo_async #(.sum_bw(bw_psum+4)) fifo_inst_ext(
  .wr_clk(clk),
  .rd_clk(clk_ext_core),
  .in(sum_q),
  .fifo_out(sum_out),
  .fifo_empty(fifo_empty),
  .fifo_full(fifo_full),
  .wr(fifo_wr),
  .wr_rst(reset),
  .rd_rst(reset),
  .rd(fifo_ext_rd)
);
reg fifo_wr_1;
fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_sum (
  .rd_clk(clk),
  .wr_clk(clk),
  .in(sum_in),
  .out(sum_other_core),
  .rd(div_q),
  .wr(wr_sum),
  .reset(reset)
);
genvar i;
for(i=1;i<col+1;i=i+1) begin :col_num
fifo_depth16 #(.bw(bw_psum)) ififo_inst(
	.rd_clk(clk),
	.wr_clk(clk),
	.in(sfp_in[bw_psum*i-1:bw_psum*(i-1)]),
	.out(sfp_in_sign[bw_psum*i-1:bw_psum*(i-1)]),
	.rd(div),
	.wr(ififo_wr),
	.reset(reset)
	);	
	end
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      cnt <= 0;
    end
    else begin
       div_q <= div ;
       acc_q <= acc;
       if (acc_q) begin
        sfp_in_reg = sfp_in;
        sum0_0_q <= sum0_0;
        sum0_1_q <= sum0_1;
        sum0_2_q <= sum0_2;
        sum0_3_q <= sum0_3;
        sum_q <= sum2;
        cnt <= cnt + 1; 
        if (cnt == 2) begin 
          cnt <= 0; 
          fifo_wr <= 1;
        end 
        else fifo_wr <= 0;
       end
       else begin
   
         if (div) begin
          fifo_wr <= 0;
           sfp_out_sign0 <= sfp_in_sign0 / sum_2core;
           sfp_out_sign1 <= sfp_in_sign1 / sum_2core;
           sfp_out_sign2 <= sfp_in_sign2 / sum_2core;
           sfp_out_sign3 <= sfp_in_sign3 / sum_2core;
           sfp_out_sign4 <= sfp_in_sign4 / sum_2core;
           sfp_out_sign5 <= sfp_in_sign5 / sum_2core;
           sfp_out_sign6 <= sfp_in_sign6 / sum_2core;
           sfp_out_sign7 <= sfp_in_sign7 / sum_2core;
         end
       end
   end
 end


endmodule