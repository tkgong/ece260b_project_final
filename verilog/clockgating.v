module clockgating(clk, en, gclk);
    input clk;
    input en;
    output gclk;
    reg en_out;
    
    always@(*) begin
        if (!clk) en_out = en;
    end
    
    assign gclk = clk && en_out;
endmodule