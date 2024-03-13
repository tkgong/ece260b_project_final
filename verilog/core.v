// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core (
        input clk_this_core, 
        input clk_ext_core, 
        input [bw_psum+3:0] sum_in,
        input [pr*bw-1:0] mem_in, 
        input [16:0] inst, 
        input reset, 
        input [3:0] norm_mem_addr, 
        input norm_mem_rd, 
        input norm_mem_wr,
        input [1:0] sfp_inst,
        input fifo_ext_rd,
        output [bw_psum*col-1:0] out,
        output [bw_psum+3:0] sum_out, 
        input wr_sum,
        output [bw_psum*col-1:0] out_sfp,
        output [bw_psum*col-1:0] array_out
        );

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+3;
parameter pr = 8;


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

wire  qmem_rd;
wire  qmem_wr; 
wire  kmem_rd;
wire  kmem_wr; 
wire  pmem_rd;
wire  pmem_wr; 

assign ofifo_rd = inst[16];
assign qkmem_add = inst[15:12];
assign pmem_add = inst[11:8];

assign qmem_rd = inst[5];
assign qmem_wr = inst[4];
assign kmem_rd = inst[3];
assign kmem_wr = inst[2];
assign pmem_rd = inst[1];
assign pmem_wr = inst[0];

assign mac_in  = inst[6] ? kmem_out : qmem_out;
assign pmem_in = fifo_out;
assign out = norm_mem_rd? norm_out: pmem_out;
assign out_sfp = sfp_out;

wire mac_array_clk;

clockgating clk_gate_inst_mac(
        .clk(clk_this_core), 
        .en((inst[7]|| inst[6]||fifo_wr)), 
        .gclk(mac_array_clk));

mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(mac_array_clk), 
        .reset(reset), 
        .inst(inst[7:6]),     
        .fifo_wr(fifo_wr),     
	.out(array_out)
);

wire ofifo_clk;
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

wire qmem_clk;
clockgating clk_gate_inst_qmem (
        .clk(clk_this_core),
        .en(qmem_rd||qmem_wr),
        .gclk(qmem_clk)
);
sram_64b_w16 qmem_instance (
        .CLK(qmem_clk),
        .D(mem_in),
        .Q(qmem_out),
        .CEN(!(qmem_rd||qmem_wr)),
        .WEN(!qmem_wr), 
        .A(qkmem_add)
);
wire kmem_clk;
clockgating clk_gate_inst_kmem (
        .clk(clk_this_core),
        .en(kmem_rd||kmem_wr),
        .gclk(kmem_clk)
);

sram_64b_w16 kmem_instance (
        .CLK(kmem_clk),
        .D(mem_in),
        .Q(kmem_out),
        .CEN(!(kmem_rd||kmem_wr)),
        .WEN(!kmem_wr), 
        .A(qkmem_add)
);
wire pmem_clk;
clockgating clk_gate_inst_pmem (
        .clk(clk_this_core),
        .en(pmem_rd||pmem_wr),
        .gclk(pmem_clk)
);

sram_152b_w16 psum_mem_instance (
        .CLK(pmem_clk),
        .D(pmem_in),
        .Q(pmem_out),
        .CEN(!(pmem_rd||pmem_wr)),
        .WEN(!pmem_wr), 
        .A(pmem_add)
);

wire [col*bw_psum-1:0] sfp_out;
wire [col*bw_psum-1:0] sfp_in;
assign sfp_in = pmem_out;

wire sfp_clk_this_core, sfp_clk_other_core;
clockgating clk_gate_inst_sfp_int (
        .clk(clk_this_core),
        .en(sfp_inst[1]||sfp_inst[0]||norm_mem_wr||pmem_rd||wr_sum),
        .gclk(sfp_clk_this_core)
);
assign sfp_clk_other_core = clk_ext_core;
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
        .wr_sum(wr_sum)
);

wire [col*bw_psum-1:0] norm_in;
assign norm_in = sfp_out;
wire [col*bw_psum-1:0] norm_out;
wire norm_mem_clk;
clockgating clk_gate_inst_norm (
        .clk(clk_this_core),
        .en(norm_mem_rd||norm_mem_wr),
        .gclk(norm_mem_clk)
);

sram_152b_w16 norm_mem_instance(
        .CLK(norm_mem_clk),
        .D(norm_in),
        .Q(norm_out),
        .CEN(!(norm_mem_rd || norm_mem_wr)),
        .WEN(!(norm_mem_wr)),
        .A(norm_mem_addr)
);

  //////////// For printing purpose ////////////
//  always @(posedge clk_this_core) begin
//      if(pmem_wr)
//         $display("Memory write to PSUM mem add %x %x for core %d", pmem_add, pmem_in, core_num); 
//  end

endmodule
