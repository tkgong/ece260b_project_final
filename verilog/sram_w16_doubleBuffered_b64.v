module sram_w16_doubleBuffer_b64(D, Q, A, CEN_EVEN, WEN_EVEN, CEN_ODD, WEN_ODD, CLK);
input [63:0] D;
input [3:0] A;
input CEN_EVEN;
input WEN_EVEN;
input CEN_ODD;
input WEN_ODD;
input CLK;
output [63:0] Q;
reg [2:0] A_EVEN, A_ODD;

always @(*) begin
    if (!A[3]) A_EVEN = A[2:0];
    else if (A[3]) A_ODD = A[2:0];
end

sram_w8 #(.sram_bit(64)) sram_w8_inst_even (
    .CLK(CLK),
    .CEN(CEN_EVEN),
    .WEN(WEN_EVEN),
    .D(D),
    .Q(Q),
    .A(A_EVEN)
);

sram_w8 #(.sram_bit(64)) sram_w8_inst_odd (
    .CLK(CLK),
    .CEN(CEN_ODD),
    .WEN(WEN_ODD),
    .D(D),
    .Q(Q),
    .A(A_ODD)
);
endmodule