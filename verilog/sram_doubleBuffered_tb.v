`timescale 1ns / 1ps

module sram_w16_doubleBuffer_b64_tb;

// Inputs
reg [63:0] D;
reg [3:0] A;
reg CEN_EVEN;
reg WEN_EVEN;
reg CEN_ODD;
reg WEN_ODD;
reg CLK;

// Output
wire [63:0] Q;

// Instantiate the Unit Under Test (UUT)
sram_w16_doubleBuffer_b64 uut (
    .D(D), 
    .Q(Q), 
    .A(A), 
    .CEN_EVEN(CEN_EVEN), 
    .WEN_EVEN(WEN_EVEN), 
    .CEN_ODD(CEN_ODD), 
    .WEN_ODD(WEN_ODD), 
    .CLK(CLK)
);

initial begin
    $dumpfile("sram_tb.vcd");
    $dumpvars(0, sram_w16_doubleBuffer_b64_tb);
    // Initialize Inputs
    #0.5 CLK = 1'b0;
    D = 0;
    A = 0;
    CEN_EVEN = 1;
    WEN_EVEN = 1;
    CEN_ODD = 1;
    WEN_ODD = 1;
    #0.5 CLK = 1'b1;
        
    // Add stimulus here
    // Example: Writing to the even bank and reading back
    #0.5 CLK = 1'b0;
    D = 64'hA5A5_A5A5_A5A5_A5A5; // Example data
    A = 4'b0000; // Address in even bank
    CEN_EVEN = 0; // Chip enable for even bank
    WEN_EVEN = 0; // Write enable for even bank
    #0.5 CLK = 1'b1;

    #0.5 CLK = 1'b1;
    CEN_EVEN = 1; WEN_EVEN = 1; // Disable write operation
    #0.5 CLK = 1'b1;

    // Example: Writing to the odd bank and reading back
    #0.5 CLK = 1'b0;
    D = 64'hA5A5_A5A5_A5A5_A5A5; // Example data
    A = 4'b1000; // Address in even bank
    CEN_ODD = 0; // Chip enable for even bank
    WEN_ODD = 0; // Write enable for even bank
    #0.5 CLK = 1'b1;

    #0.5 CLK = 1'b1;
    CEN_ODD = 1; WEN_ODD = 1; // Disable write operation
    #0.5 CLK = 1'b1;
    // More tests can be added following the same pattern
    #10 $finish;
end


endmodule
