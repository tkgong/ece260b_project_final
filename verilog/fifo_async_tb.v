`timescale 1ns / 1ps

module fifo_async_tb;

parameter SUM_BW = 22;
parameter PTR_LEN = 4;

// Testbench signals
reg wr_clk, rd_clk, wr_rstn, rd_rstn, wr, rd;
reg [SUM_BW-1:0] in;
wire [SUM_BW-1:0] out;
wire fifo_empty, fifo_full;

// Instance of the FIFO
fifo_async #(
    .sum_bw(SUM_BW),
    .ptr_len(PTR_LEN)
) uut (
    .wr_clk(wr_clk), .rd_clk(rd_clk),
    .wr_rstn(wr_rstn), .rd_rstn(rd_rstn),
    .wr(wr), .rd(rd),
    .in(in), .out(out),
    .fifo_empty(fifo_empty), .fifo_full(fifo_full),
    .direction(1'b0) // Assuming direction is not used in your provided code
);

// Clock generation
initial begin
    wr_clk = 0;
    rd_clk = 0;
    forever begin
        #5 wr_clk = ~wr_clk; // 100 MHz clock
        #8 rd_clk = ~rd_clk; // ~62.5 MHz clock, different frequency to simulate asynchronous operation
    end
end

// Test sequence
initial begin
      $dumpfile("fifo_async_tb.vcd");
    $dumpvars(0,fifo_async_tb);
    // Initialize
    wr_rstn = 0; rd_rstn = 0;
    wr = 0; rd = 0;
    in = 0;

    // Reset release
    #100;
    wr_rstn = 1; rd_rstn = 1;

    // Write operations
    repeat (30) begin
        @ (posedge wr_clk);
        wr = 1;
        in = in + 1;
        @ (posedge wr_clk);
        wr = 0;
    end
    
    // Wait for a bit
    #50;

    // Read operations
    repeat (30) begin
        @ (posedge rd_clk);
        rd = 1;
        @ (posedge rd_clk);
        rd = 0;
        $display("%d", out);
    end
    
    // Complete
    #100;
    $finish;
end

endmodule
