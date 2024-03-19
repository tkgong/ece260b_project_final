// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip #(parameter col = 8,
                  parameter bw = 8,
                  parameter bw_psum = 2*bw+3,
                  parameter pr = 8) (input clk_core1, 
                  input clk_core2, 
                  input [bw*pr-1:0] mem_in_core1, 
                  input [bw*pr-1:0] mem_in_core2, 
                  input[29:0] inst_core1, 
		  input [29:0] inst_core2,
                  input reset, 
                  output [col*bw_psum-1:0] out_core1, 
                  output [col*bw_psum-1:0] out_core2, 
                  input [1:0] async_interface_rd,
                  input [1:0] async_interface_wr,
                  output [col*bw_psum-1:0] out_sfp_core1,
                  output [col*bw_psum-1:0] out_sfp_core2);

// wire [1:0] sfp_inst_core1, sfp_inst_core2;
// assign sfp_inst_core1 = sfp_inst[1:0];
// assign sfp_inst_core2 = sfp_inst[3:2];

// wire [3:0] norm_mem_addr_core1, norm_mem_addr_core2;
// assign norm_mem_addr_core1 = norm_mem_addr[3:0];
// assign norm_mem_addr_core2 = norm_mem_addr[7:4];

// wire norm_mem_rd_core1, norm_mem_rd_core2;
// assign norm_mem_rd_core1 = norm_mem_rd[0];
// assign norm_mem_rd_core2 = norm_mem_rd[1];

wire fifo_ext_rd_core1, fifo_ext_rd_core2;
assign fifo_ext_rd_core1 = async_interface_rd[0];
assign fifo_ext_rd_core2 = async_interface_rd[1];

wire wr_sum_core1, wr_sum_core2;
assign wr_sum_core1 = async_interface_wr[0];
assign wr_sum_core2 = async_interface_wr[1];

wire [bw_psum+3:0] sum_in_core1, sum_in_core2, sum_out_core1, sum_out_core2;
assign sum_in_core2 = sum_out_core1;
assign sum_in_core1 = sum_out_core2;


// wire norm_mem_wr_core1, norm_mem_wr_core2;
// assign norm_mem_wr_core1 = norm_mem_wr[0];
// assign norm_mem_wr_core2 = norm_mem_wr[1];

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core1_instance (
      .clk_this_core(clk_core1), 
      .clk_ext_core(clk_core2), 
      .mem_in(mem_in_core1), 
      .out(out_core1), 
      .inst(inst_core1), 
      .reset(reset), 
      //.norm_mem_addr(norm_mem_addr_core1), 
      //.norm_mem_rd(norm_mem_rd_core1), 
      //.sfp_inst(sfp_inst_core1),
      .fifo_ext_rd(fifo_ext_rd_core1),
      .sum_in(sum_in_core1),
      .sum_out(sum_out_core1),
      .out_sfp(out_sfp_core1),
      .wr_sum(wr_sum_core1)
      //.norm_mem_wr(norm_mem_wr_core1),
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core2_instance (
      .clk_this_core(clk_core2), 
      .clk_ext_core(clk_core1), 
      .mem_in(mem_in_core2), 
      .out(out_core2), 
      .inst(inst_core2), 
      .reset(reset), 
      //.norm_mem_addr(norm_mem_addr_core2), 
      //.norm_mem_rd(norm_mem_rd_core2), 
      //.sfp_inst(sfp_inst_core2),
      .fifo_ext_rd(fifo_ext_rd_core2),
      .sum_in(sum_in_core2),
      .sum_out(sum_out_core2),
      .out_sfp(out_sfp_core2),
      .wr_sum(wr_sum_core2)
      //.norm_mem_wr(norm_mem_wr_core2),
);

endmodule
