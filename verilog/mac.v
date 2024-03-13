module mac(a, b, out, clk, reset);
parameter  pr = 8;
parameter bw =8;
parameter bw_psum = 2*bw+3;
input [pr*bw-1:0] a;
input [pr*bw-1:0] b;
input reset;
input clk;
output [bw_psum-1:0] out;

wire		[2*bw-1:0]	product0	;
wire		[2*bw-1:0]	product1	;
wire		[2*bw-1:0]	product2	;
wire		[2*bw-1:0]	product3	;
wire		[2*bw-1:0]	product4	;
wire		[2*bw-1:0]	product5	;
wire		[2*bw-1:0]	product6	;
wire		[2*bw-1:0]	product7	;

assign	product0	=	{{(bw){a[bw*	1	-1]}},	a[bw*	1	-1:bw*	0	]}	*	{{(bw){b[bw*	1	-1]}},	b[bw*	1	-1:	bw*	0	]};
assign	product1	=	{{(bw){a[bw*	2	-1]}},	a[bw*	2	-1:bw*	1	]}	*	{{(bw){b[bw*	2	-1]}},	b[bw*	2	-1:	bw*	1	]};
assign	product2	=	{{(bw){a[bw*	3	-1]}},	a[bw*	3	-1:bw*	2	]}	*	{{(bw){b[bw*	3	-1]}},	b[bw*	3	-1:	bw*	2	]};
assign	product3	=	{{(bw){a[bw*	4	-1]}},	a[bw*	4	-1:bw*	3	]}	*	{{(bw){b[bw*	4	-1]}},	b[bw*	4	-1:	bw*	3	]};
assign	product4	=	{{(bw){a[bw*	5	-1]}},	a[bw*	5	-1:bw*	4	]}	*	{{(bw){b[bw*	5	-1]}},	b[bw*	5	-1:	bw*	4	]};
assign	product5	=	{{(bw){a[bw*	6	-1]}},	a[bw*	6	-1:bw*	5	]}	*	{{(bw){b[bw*	6	-1]}},	b[bw*	6	-1:	bw*	5	]};
assign	product6	=	{{(bw){a[bw*	7	-1]}},	a[bw*	7	-1:bw*	6	]}	*	{{(bw){b[bw*	7	-1]}},	b[bw*	7	-1:	bw*	6	]};
assign	product7	=	{{(bw){a[bw*	8	-1]}},	a[bw*	8	-1:bw*	7	]}	*	{{(bw){b[bw*	8	-1]}},	b[bw*	8	-1:	bw*	7	]};

reg [2*bw-1:0] product0_reg,product1_reg,product2_reg,product3_reg, product4_reg,product5_reg,product6_reg,product7_reg;
reg [bw_psum -1:0] out_reg;
wire [bw_psum-1:0] psum;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		product0_reg <= 0;
		product1_reg <= 0;
		product2_reg <= 0;
		product3_reg <= 0;
		product4_reg <= 0;
		product5_reg <= 0;
		product6_reg <= 0;
		product7_reg <= 0;
		out_reg <= 0;
	end
	
	else begin
		product0_reg <= product0;
		product1_reg <= product1;
		product2_reg <= product2;
		product3_reg <= product3;
		product4_reg <= product4;
		product5_reg <= product5;
		product6_reg <= product6;
		product7_reg <= product7;
		out_reg <= psum;
	end
		
end

assign psum = {{(4){product0_reg[2*bw-1]}},product0_reg	}
	        +{{(4){product1_reg[2*bw-1]}},product1_reg	}
	        +{{(4){product2_reg[2*bw-1]}},product2_reg	}
	        +{{(4){product3_reg[2*bw-1]}},product3_reg	}
	        +{{(4){product4_reg[2*bw-1]}},product4_reg	}
	        +{{(4){product5_reg[2*bw-1]}},product5_reg	}
	        +{{(4){product6_reg[2*bw-1]}},product6_reg	}
	        +{{(4){product7_reg[2*bw-1]}},product7_reg	};
assign out = out_reg;

endmodule