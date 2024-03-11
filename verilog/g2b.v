module g2b(gray, binary);
input [4:0] gray;
output [4:0] binary;

assign binary[0] = gray[4] ^ gray[3] ^ gray[2] ^ gray[1] ^ gray[0];
assign binary[1] = gray[4] ^ gray[3] ^ gray[2] ^ gray[1];
assign binary[2] = gray[4] ^ gray[3] ^ gray[2];
assign binary[3] = gray[4] ^ gray[3];
assign binary[4] = gray[4];
endmodule