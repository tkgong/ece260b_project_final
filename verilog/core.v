// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core #( parameter bw = 8,
	parameter bw_psum = 2*bw+3,
	parameter pr = 8,
	parameter col = 8
) (
        input clk_this_core, 
        input clk_ext_core, 
        input [bw_psum+3:0] sum_in,
        input [pr*bw-1:0] mem_in, 
        input [29:0] inst, 
        input reset, 
        input fifo_ext_rd,
        output [bw_psum*col-1:0] out,
        output [bw_psum+3:0] sum_out, 
        input wr_sum
        );
wire   [bw_psum*col-1:0] pmem_out;
wire  [pr*bw-1:0] mac_in;
wire  [pr*bw-1:0] kmem_out;
wire  [pr*bw-1:0] qmem_out;
wire  [bw_psum*col-1:0] pmem_in;
wire  [bw_psum*col-1:0] fifo_out;
wire  [col-1:0] fifo_wr;
wire  ofifo_rd;
wire [3:0] qkmem_add;
wire [3:0] pmem_add;
wire mac_loadk, mac_exe;
wire  qmem_even_rd;
wire  qmem_even_wr;
wire  qmem_odd_wr;
wire qmem_odd_rd; 
wire  kmem_even_rd;
wire kmem_odd_rd;
wire  kmem_even_wr; 
wire kmem_odd_wr;
wire pmem_wr;
wire pmem_rd;
wire norm_mem_wr;
wire norm_mem_rd;
wire [3:0] norm_mem_addr;
wire [1:0] sfp_inst;
wire mac_array_clk;
wire ofifo_clk;
wire qmem_clk;
wire pmem_clk;
wire [col*bw_psum-1:0] sfp_out;
wire [col*bw_psum-1:0] sfp_in;
wire [col*bw_psum-1:0] array_out;
wire kmem_clk;
wire sfp_clk_this_core, sfp_clk_other_core;
wire [col*bw_psum-1:0] norm_in;
reg [col*bw_psum-1:0] out_reg;
wire [col*bw_psum-1:0] norm_out;
wire norm_mem_clk;
wire sfp_ififo_wr;
assign sfp_in = pmem_out;
assign norm_in = sfp_out;
assign pmem_wr = inst[0];
assign pmem_rd = inst[1];
assign kmem_even_wr = inst[2];
assign kmem_odd_wr = inst[3];
assign kmem_even_rd = inst[4];
assign kmem_odd_rd = inst[5];
assign qmem_even_wr = inst[6];
assign qmem_odd_wr = inst[7];
assign qmem_even_rd = inst[8];
assign qmem_odd_rd = inst[9];
assign pmem_add = inst[13:10];
assign qkmem_add = inst[17:14];
assign ofifo_rd = inst[18];
assign mac_loadk = inst[19];
assign mac_exe = inst[20];
assign norm_mem_wr = inst[21];
assign norm_mem_rd = inst[22];
assign norm_mem_addr = inst[26:23];
assign sfp_inst[0] = inst[27];
assign sfp_inst[1] = inst[28];
assign sfp_ififo_wr = inst[29];
assign sfp_clk_other_core = clk_ext_core;

assign mac_in  = inst[19] ? kmem_out : qmem_out;
assign pmem_in = fifo_out;
assign out = out_reg;

clockgating clk_gate_inst_mac(
        .clk(clk_this_core), 
        .en((inst[20]|| inst[19]||fifo_wr)), 
        .gclk(mac_array_clk));

mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(mac_array_clk), 
        .reset(reset), 
        .inst(inst[20:19]),     
        .fifo_wr(fifo_wr),     
	.out(array_out)
);


clockgating clk_gate_inst_ofifo (
        .clk(clk_this_core),
        .en(fifo_wr || ofifo_rd),
        .gclk(ofifo_clk)
);

ofifo #(.bw(bw_psum), .col(col))  ofifo_inst (
        .reset(reset),
        .clk(ofifo_clk),
        .in(array_out),
        .wr(fifo_wr),
        .rd(ofifo_rd),
        .o_valid(fifo_valid),
        .out(fifo_out)
);


clockgating clk_gate_inst_qmem (
        .clk(clk_this_core),
        .en(qmem_even_rd||qmem_even_wr||qmem_odd_rd||qmem_even_wr),
        .gclk(qmem_clk)
);
sram_w16_doubleBuffered_b64 qmem_instance (
        .CLK(qmem_clk),
        .D(mem_in),
        .Q(qmem_out),
        .CEN_EVEN(!(qmem_even_rd||qmem_even_wr)),
        .WEN_EVEN(!qmem_even_wr), 
        .CEN_ODD(!(qmem_odd_rd || qmem_odd_wr)),
        .WEN_ODD(!qmem_odd_wr),
        .A(qkmem_add)
);

clockgating clk_gate_inst_kmem (
        .clk(clk_this_core),
        .en(kmem_even_rd || kmem_odd_rd || kmem_even_wr || kmem_odd_wr),
        .gclk(kmem_clk)
);

sram_w16_doubleBuffered_b64 kmem_instance (
        .CLK(kmem_clk),
        .D(mem_in),
        .Q(kmem_out),
        .CEN_EVEN(!(kmem_even_rd||kmem_even_wr)),
        .WEN_EVEN(!kmem_even_wr), 
        .CEN_ODD(!(kmem_odd_rd || kmem_odd_wr)),
        .WEN_ODD(!kmem_odd_wr),
        .A(qkmem_add)
);

clockgating clk_gate_inst_pmem (
        .clk(clk_this_core),
        .en(pmem_wr || pmem_rd),
        .gclk(pmem_clk)
);

sram_152b_w8 psum_mem_instance (
        .CLK(pmem_clk),
        .D(pmem_in),
        .Q(pmem_out),
        .CEN(!(pmem_wr || pmem_rd)),
        .WEN(~pmem_wr),
        .A(pmem_add)
);


clockgating clk_gate_inst_sfp_int (
        .clk(clk_this_core),
        .en(sfp_inst[1]||sfp_inst[0]||norm_mem_wr||pmem_rd||wr_sum||sfp_ififo_wr),
        .gclk(sfp_clk_this_core)
);

sfp_row#(.bw(bw), .bw_psum(bw_psum), .col(col)) sfp_instance (
        .clk(sfp_clk_this_core), 
        .sfp_inst(sfp_inst), 
        .fifo_ext_rd(fifo_ext_rd), 
        .sum_in(sum_in), 
        .sum_out(sum_out), 
        .sfp_in(sfp_in), 
        .sfp_out(sfp_out), 
        .clk_ext_core(sfp_clk_other_core), 
        .reset(reset),
        .wr_sum(wr_sum),
	.ififo_wr(sfp_ififo_wr)
);

clockgating clk_gate_inst_norm (
        .clk(clk_this_core),
        .en(norm_mem_rd||norm_mem_wr),
        .gclk(norm_mem_clk)
);

sram_152b_w8 norm_mem_instance(
        .CLK(norm_mem_clk),
        .D(norm_in),
        .Q(norm_out),
        .CEN(!(norm_mem_rd || norm_mem_wr)),
        .WEN(!(norm_mem_wr)),
        .A(norm_mem_addr)
);
always @(posedge clk_this_core ) begin
        if (pmem_rd) out_reg <= pmem_out;
        else if (norm_mem_rd) out_reg <= norm_out;
	else out_reg <= out_reg;
end
endmodule
