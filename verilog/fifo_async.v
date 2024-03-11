module fifo_async(wr_clk, rd_clk, in, fifo_out, fifo_empty, fifo_full, rd_rstn, wr_rstn, wr, rd);
parameter sum_bw = 23;
parameter ptr_len = 4;

input wr, rd;
input rd_rstn, wr_rstn;
input wr_clk, rd_clk;
input [sum_bw-1:0] in;
output [sum_bw-1:0] fifo_out;
output fifo_empty, fifo_full;

reg [ptr_len:0] rd_ptr = 4'b0000;
reg [ptr_len:0] wr_ptr = 4'b0000;
wire [ptr_len:0] rd_ptr_t;
wire [ptr_len:0] wr_ptr_r;
wire [ptr_len:0] rd_ptr_grey;
wire [ptr_len:0] wr_ptr_grey;

reg [sum_bw-1:0] q0;
reg [sum_bw-1:0] q1;
reg [sum_bw-1:0] q2;
reg [sum_bw-1:0] q3;
reg [sum_bw-1:0] q4;
reg [sum_bw-1:0] q5;
reg [sum_bw-1:0] q6;
reg [sum_bw-1:0] q7;
reg [sum_bw-1:0] q8;
reg [sum_bw-1:0] q9;
reg [sum_bw-1:0] q10;
reg [sum_bw-1:0] q11;
reg [sum_bw-1:0] q12;
reg [sum_bw-1:0] q13;
reg [sum_bw-1:0] q14;
reg [sum_bw-1:0] q15;

wire [sum_bw-1:0] out_reg;
wire empty, full;

b2g binary_to_gray_instance_rd(.binary(rd_ptr), .gray(rd_ptr_grey));
b2g binary_to_gray_instance_wr(.binary(wr_ptr), .gray(wr_ptr_grey));


fifo_mux_16_1 #(.bw(sum_bw), .simd(1)) fifo_mux_16_instance (.in0(q0), .in1(q1), .in2(q2), .in3(q3), .in4(q4), .in5(q5), .in6(q6), .in7(q7),
                                 .in8(q8), .in9(q9), .in10(q10), .in11(q11), .in12(q12), .in13(q13), .in14(q14), .in15(q15),
	                         .sel(rd_ptr[3:0]), .out(out_reg));


sync_5b sync_r2w_instance(.clk(wr_clk), .in(rd_ptr_grey), .out(rd_ptr_t));
sync_5b sync_w2r_instance(.clk(rd_clk), .in(wr_ptr_grey), .out(wr_ptr_r));

assign full = (wr_ptr_grey == {~rd_ptr_t[ptr_len:ptr_len-1], rd_ptr_t[ptr_len-2:0]})? 1: 0;
assign empty = (rd_ptr_grey == wr_ptr_r)? 1:0;
assign fifo_full = full;
assign fifo_empty = empty;

assign fifo_out = out_reg;
// write operation

always @(posedge wr_clk ) begin
    if (!wr_rstn) wr_ptr <= 0;

    else begin
        if (wr && !full) begin
            wr_ptr <= wr_ptr + 1;
        end

        if (wr) begin
            case (wr_ptr[3:0])
                4'b0000   :    q0  <= in ;
                4'b0001   :    q1  <= in ;
                4'b0010   :    q2  <= in ;
                4'b0011   :    q3  <= in ;
                4'b0100   :    q4  <= in ;
                4'b0101   :    q5  <= in ;
                4'b0110   :    q6  <= in ;
                4'b0111   :    q7  <= in ;
                4'b1000   :    q8  <= in ;
                4'b1001   :    q9  <= in ;
                4'b1010   :    q10 <= in ;
                4'b1011   :    q11 <= in ;
                4'b1100   :    q12 <= in ;
                4'b1101   :    q13 <= in ;
                4'b1110   :    q14 <= in ;
                4'b1111   :    q15 <= in ;
            endcase
        end
    end
end

//read operation

always @(posedge rd_clk ) begin
    if (!rd_rstn) rd_ptr <=5'b00000;

    else begin
        if ((rd==1) && (empty == 0)) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
end
endmodule