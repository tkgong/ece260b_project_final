module sram_w8 (CLK, WEN, CEN, D, Q, A);
parameter sram_bit = 64;
input CLK;
input WEN;
input CEN;
input [sram_bit-1:0] D;
output reg [sram_bit-1:0] Q;
input [2:0] A;

reg [sram_bit-1:0] memory0;
reg [sram_bit-1:0] memory1;
reg [sram_bit-1:0] memory2;
reg [sram_bit-1:0] memory3;
reg [sram_bit-1:0] memory4;
reg [sram_bit-1:0] memory5;
reg [sram_bit-1:0] memory6;
reg [sram_bit-1:0] memory7;

always @(posedge CLK) begin
    if (!CEN && WEN) begin
        case (A)
            3'b000: Q <= memory0;
            3'b001: Q <= memory1;
            3'b010: Q <= memory2;
            3'b011: Q <= memory3;
            3'b100: Q <= memory4;
            3'b101: Q <= memory5;
            3'b110: Q <= memory6;
            3'b111: Q <= memory7;
        endcase
    end

    else if (!CEN && !WEN) begin
        case (A)
            3'b000: memory0 <= D;
            3'b001: memory1 <= D;
            3'b010: memory2 <= D;
            3'b011: memory3 <= D;
            3'b100: memory4 <= D;
            3'b101: memory5 <= D;
            3'b110: memory6 <= D;
            3'b111: memory7 <= D;
        endcase
    end
end
endmodule