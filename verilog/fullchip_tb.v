// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns/1ps

module fullchip_tb;

parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 8;            // Q & K vector bit precision
parameter bw_psum = 2*bw+3;  // partial sum bit precision
parameter pr = 8;           // how many products added in each dot product 
parameter col = 8;           // how many dot product units are equipped

integer qk_file ; // file handler
integer qk_scan_file ; // file handler


integer  captured_data;
integer  weight [col*pr-1:0];
`define NULL 0




integer  K_core1[col-1:0][pr-1:0];
integer  K_core2[col-1:0][pr-1:0];
integer  Q[total_cycle-1:0][pr-1:0];
integer  result_core1[total_cycle-1:0][col-1:0];
integer  result_core2[total_cycle-1:0][col-1:0];
reg signed [bw_psum+3:0]  sum_core1[total_cycle-1:0];
reg signed [bw_psum+3:0]  sum_core2[total_cycle-1:0];
reg signed [bw_psum-1:0]  sum_2cores[total_cycle-1:0];
reg signed [bw_psum-1:0]  psum_core1[total_cycle-1:0][col-1:0];
reg signed [bw_psum-1:0] psum_core1_abs[total_cycle-1:0][col-1:0];
reg signed [bw_psum-1:0]  psum_core2[total_cycle-1:0][col-1:0];
reg signed [bw_psum-1:0] psum_core2_abs[total_cycle-1:0][col-1:0];
integer i,j,k,t,p,q,s,u, m;





reg reset = 1;
reg clk = 0;
reg [pr*bw-1:0] mem_in_core1; 
reg [pr*bw-1:0] mem_in_core2; 
wire [59:0] inst;


reg pmem_wr_core1 = 0; // inst[0]
reg pmem_rd_core1 = 0;//inst[3];
reg kmem_even_wr_core1 =0; //inst[4];
reg kmem_odd_wr_core1 =0;// inst[5];
reg kmem_even_rd_core1 =0;// inst[6];
reg  kmem_odd_rd_core1 =0;// inst[7];
reg qmem_even_wr_core1 =0;// inst[8];
reg qmem_odd_wr_core1 = 0;//inst[9];
reg qmem_even_rd_core1 =0;// inst[10];
reg qmem_odd_rd_core1 = 0;//inst[11];
reg [3:0] pmem_add_core1 = 0;//inst[15:12];
reg [3:0] qkmem_add_core1 =0;// inst[19:16];
reg ofifo_rd_core1 = 0;//inst[20];
reg mac_loadk_core1 =0; //inst[21];
reg mac_exe_core1 = 0;//inst[22];
reg norm_mem_wr_core1 = 0;//inst[23];
reg norm_mem_rd_core1 =0; //inst[24];
reg [3:0] norm_mem_addr_core1 = 0;//inst[28:25];
reg sfp_acc_core1 = 0;//inst[29];
reg sfp_div_core1 = 0;//inst[30];

reg pmem_wr_core2 = 0; // inst[31]
reg pmem_rd_core2 = 0;//inst[34];
reg kmem_even_wr_core2 =0; //inst[35];
reg kmem_odd_wr_core2 =0;// inst[36];
reg kmem_even_rd_core2 =0;// inst[37];
reg  kmem_odd_rd_core2 =0;// inst[38];
reg qmem_even_wr_core2 =0;// inst[39];
reg qmem_odd_wr_core2 = 0;//inst[40];
reg qmem_even_rd_core2 =0;// inst[41];
reg qmem_odd_rd_core2 = 0;//inst[42];
reg [3:0] pmem_add_core2 = 0;//inst[46:43];
reg [3:0] qkmem_add_core2 =0;// inst[50:47];
reg ofifo_rd_core2 = 0;//inst[51];
reg mac_loadk_core2 =0; //inst[52];
reg mac_exe_core2 = 0;//inst[53];
reg norm_mem_wr_core2 = 0;//inst[54];
reg norm_mem_rd_core2 =0; //inst[55];
reg [3:0] norm_mem_addr_core2 = 0;//inst[59:56];
reg sfp_acc_core2 = 0;//inst[60];
reg sfp_div_core2 = 0;
reg sfp_ififo_wr_core1 = 0;
reg sfp_ififo_wr_core2 = 0;


assign inst[0] = pmem_wr_core1;
assign inst[1] = pmem_rd_core1;
assign inst[2] = kmem_even_wr_core1;
assign inst[3] = kmem_odd_wr_core1;
assign inst[4] = kmem_even_rd_core1;
assign inst[5] = kmem_odd_rd_core1;
assign inst[6] = qmem_even_wr_core1;
assign inst[7] = qmem_odd_wr_core1;
assign inst[8] = qmem_even_rd_core1;
assign inst[9] = qmem_odd_rd_core1;

assign inst[13:10] = pmem_add_core1;
assign inst[17:14] = qkmem_add_core1;
assign inst[18] = ofifo_rd_core1;
assign inst[19] = mac_loadk_core1;
assign inst[20] = mac_exe_core1;
assign inst[21] = norm_mem_wr_core1;
assign inst[22] = norm_mem_rd_core1;
assign inst[26:23] = norm_mem_addr_core1;
assign inst[27] = sfp_acc_core1;
assign inst[28] = sfp_div_core1;
assign inst[29] = sfp_ififo_wr_core1;

assign inst[30] = pmem_wr_core2;
assign inst[31] = pmem_rd_core2;
assign inst[32] = kmem_even_wr_core2;
assign inst[33] = kmem_odd_wr_core2;
assign inst[34] = kmem_even_rd_core2;
assign inst[35] = kmem_odd_rd_core2;
assign inst[36] = qmem_even_wr_core2;
assign inst[37] = qmem_odd_wr_core2;
assign inst[38] = qmem_even_rd_core2;
assign inst[39] = qmem_odd_rd_core2;
assign inst[43:40] = pmem_add_core2;
assign inst[47:44] = qkmem_add_core2;
assign inst[48] = ofifo_rd_core2;
assign inst[49] = mac_loadk_core2;
assign inst[50] = mac_exe_core2;
assign inst[51] = norm_mem_wr_core2;
assign inst[52] = norm_mem_rd_core2;
assign inst[56:53] = norm_mem_addr_core2;
assign inst[57] = sfp_acc_core2;
assign inst[58] = sfp_div_core2;
assign inst[59] = sfp_ififo_wr_core2;

wire [1:0] async_interface_rd;
reg fifo_ext_rd_core1 = 0;
reg fifo_ext_rd_core2 = 0;
assign async_interface_rd[0] = fifo_ext_rd_core1;
assign async_interface_rd[1] = fifo_ext_rd_core2;
wire [1:0] async_interface_wr;
reg wr_sum_core1 = 0;
reg wr_sum_core2 = 0;
assign async_interface_wr[0] = wr_sum_core1;
assign async_interface_wr[1] = wr_sum_core2;




reg [bw_psum-1:0] temp5b;
reg [bw_psum+3:0] temp_sum;
reg [bw_psum*col-1:0] temp16b;
reg [bw_psum*col-1:0] multiplication_result_core1[total_cycle];
reg [bw_psum*col-1:0] multiplication_result_core2[total_cycle];
reg signed [bw_psum-1:0] temp5b_core1, temp5b_core2;
reg signed [bw_psum-1:0] abs_temp5b_core1, abs_temp5b_core2;
reg signed [bw_psum+3:0] temp_sum_core1, temp_sum_core2;
reg signed [bw_psum+3:0] psum_sign_extend;
reg signed [bw_psum*col-1:0] temp16b_core1, temp16b_core2;
reg [bw_psum*col-1:0] norm_out_col_core1[total_cycle-1:0];
reg [bw_psum*col-1:0] norm_out_col_core2[total_cycle-1:0];
reg signed [bw_psum-1:0] norm_out_core1[total_cycle-1:0][col-1:0]; 
reg signed [bw_psum-1:0] norm_out_core2[total_cycle-1:0][col-1:0]; 
wire [col*bw_psum-1:0] out_core1;
wire [col*bw_psum-1:0] out_core2;

wire [col*bw_psum-1:0] array_out_core1; 
wire [col*bw_psum-1:0] array_out_core2;


fullchip#(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
  .clk_core1(clk),
  .clk_core2(clk),
  .mem_in_core1(mem_in_core1),
  .mem_in_core2(mem_in_core2),
  .inst_core1(inst[29:0]),
  .inst_core2(inst[59:30]),
  .reset(reset),
  .out_core1(out_core1),
  .out_core2(out_core2),
  .async_interface_rd(async_interface_rd),
  .async_interface_wr(async_interface_wr)
);



initial begin 

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);



///// Q data txt reading /////

$display("##### Q data txt reading #####");


  qk_file = $fopen("qdata.txt", "r");

  //// To get rid of first 3 lines in data file ////
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);


  for (q=0; q<total_cycle; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          if(j<pr) begin
          Q[q][j] = captured_data;
          //$display("Q_core1[%d][%d]:%d", q, j, Q[q][j]);
          end
          else begin
            Q[q][j] = captured_data;
            //$display("Q_core2[%d][%d]:%d", q, j, Q[q][j]);
          end
          //$display("%d\n", K[q][j]);
    end
  end
/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end




///// core1 K data txt reading /////

$display("##### K data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end
  reset = 0;

  qk_file = $fopen("kdata_core0.txt", "r");

  //// To get rid of first 4 lines in data file ////
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);




  for (q=0; q<col; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K_core1[q][j] = captured_data;
          //$display("K_core1[%d][%d] is %d", q, j, K_core1[q][j]);
    end
  end
/////////////////////////////////


///// core2 K data txt reading /////

$display("##### K data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end
  reset = 0;

  qk_file = $fopen("kdata_core1.txt", "r");

  //// To get rid of first 4 lines in data file ////
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);
  //qk_scan_file = $fscanf(qk_file, "%s\n", captured_data);




  for (q=0; q<col; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file = $fscanf(qk_file, "%d\n", captured_data);
          K_core2[q][j] = captured_data;
          //$display("K_core2[%d][%d] : %d", q, j, K_core2[q][j]);
    end
  end
/////////////////////////////////





/////////////// Estimated result printing /////////////////


$display("##### Estimated multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result_core1[t][q] = 0;
       norm_out_core1[t][q] = 0;
       result_core2[t][q] = 0;
       norm_out_core2[t][q] = 0;
     end
     norm_out_col_core1[t] = 0;
     norm_out_col_core2[t] = 0;
     sum_core1[t]=0;
     sum_core2[t]=0;
     sum_2cores[t]=0;
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result_core1[t][q] = result_core1[t][q] + Q[t][k] * K_core1[q][k];
            result_core2[t][q] = result_core2[t][q] + Q[t][k] * K_core2[q][k];
         end
        temp5b_core1 = result_core1[t][q];
	      psum_core1[t][q] = temp5b_core1;
        temp16b_core1 = {temp16b_core1[139:0], temp5b_core1};
	      abs_temp5b_core1 = (temp5b_core1[bw_psum - 1])? ~temp5b_core1+1:temp5b_core1;
        psum_core1_abs[t][q] = abs_temp5b_core1;
	      sum_core1[t] = sum_core1[t] + {4'b0, abs_temp5b_core1};
        temp5b_core2 = result_core2[t][q];
	      psum_core2[t][q] = temp5b_core2;
        temp16b_core2 = {temp16b_core2[139:0], temp5b_core2};
	      abs_temp5b_core2 = (temp5b_core2[bw_psum - 1])? ~temp5b_core2+1:temp5b_core2;
        psum_core2_abs[t][q] = abs_temp5b_core2;
	      sum_core2[t] = sum_core2[t] + {4'b0, abs_temp5b_core2};
     end

   // $display("@cycle%2d: core 1 %h, core 2 %h", t, temp16b_core1, temp16b_core2);
    multiplication_result_core1[t] = temp16b_core1;
    multiplication_result_core2[t] = temp16b_core2;
    //$display("%h,%h", multiplication_result_core1[t], multiplication_result_core2[t]);
     //$display("sum @cycle:%2d: core1 %8h core2 %8h", t, sum_core1[t], sum_core2[t]);
  end

//////////////////////////////////////////////

$display("##### Estimated Normalization result #####");
  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       sum_2cores[t] = sum_core1[t][bw_psum+3:7]+sum_core2[t][bw_psum+3:7];
       result_core1[t][q] = psum_core1_abs[t][q]/sum_2cores[t];
       result_core2[t][q] = psum_core2_abs[t][q]/sum_2cores[t];
       norm_out_core1[t][q] = result_core1[t][q];
       norm_out_core2[t][q] = result_core2[t][q];
       norm_out_col_core1[t] = {norm_out_col_core1[t][139:0], norm_out_core1[t][q]};
       norm_out_col_core2[t] = {norm_out_col_core2[t][139:0], norm_out_core2[t][q]};
     end
     //$display("Core1 normalized out @cycle%2d: %40h", t, norm_out_col_core1[t]);
     //$display("Core2 normalized out @cycle%2d: %40h", t, norm_out_col_core2[t]);
  end






///// Qmem writing  /////

$display("##### Qmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin
    //give one cycle at first
    
    #0.5 clk = 1'b0;  
    qmem_even_wr_core1 = 1; qmem_even_wr_core2 = 1;  
    if (q == 0) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end
    if (q>0) begin 
      qkmem_add_core1 = qkmem_add_core1 + 1;
      qkmem_add_core2 = qkmem_add_core2 + 1;
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end

    
    mem_in_core1[1*bw-1:0*bw] = Q[q][0];
    mem_in_core1[2*bw-1:1*bw] = Q[q][1];
    mem_in_core1[3*bw-1:2*bw] = Q[q][2];
    mem_in_core1[4*bw-1:3*bw] = Q[q][3];
    mem_in_core1[5*bw-1:4*bw] = Q[q][4];
    mem_in_core1[6*bw-1:5*bw] = Q[q][5];
    mem_in_core1[7*bw-1:6*bw] = Q[q][6];
    mem_in_core1[8*bw-1:7*bw] = Q[q][7];

    mem_in_core2[1*bw-1:0*bw] = Q[q][0];
    mem_in_core2[2*bw-1:1*bw] = Q[q][1];
    mem_in_core2[3*bw-1:2*bw] = Q[q][2];
    mem_in_core2[4*bw-1:3*bw] = Q[q][3];
    mem_in_core2[5*bw-1:4*bw] = Q[q][4];
    mem_in_core2[6*bw-1:5*bw] = Q[q][5];
    mem_in_core2[7*bw-1:6*bw] = Q[q][6];
    mem_in_core2[8*bw-1:7*bw] = Q[q][7];
    //$display("mem_in_core1 in cycle : %d is %h", q+1, mem_in_core1);

    #0.5 clk = 1'b1;  

  end


  #0.5 clk = 1'b0;  
  qmem_even_wr_core1 = 0;
  qmem_even_wr_core2 = 0; 
  qkmem_add_core1 = 0;
  qkmem_add_core2 = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////





///// Kmem writing  /////

$display("##### Kmem writing #####");

  for (q=0; q<col; q=q+1) begin
    
    #0.5 clk = 1'b0;  
    kmem_even_wr_core1 = 1;
    kmem_even_wr_core2 = 1;
    if (q>0) 
    begin
      qkmem_add_core1 = qkmem_add_core1 + 1;
      qkmem_add_core2 = qkmem_add_core2 + 1; 
    end
    mem_in_core1[1*bw-1:0*bw] = K_core1[q][0];
    mem_in_core1[2*bw-1:1*bw] = K_core1[q][1];
    mem_in_core1[3*bw-1:2*bw] = K_core1[q][2];
    mem_in_core1[4*bw-1:3*bw] = K_core1[q][3];
    mem_in_core1[5*bw-1:4*bw] = K_core1[q][4];
    mem_in_core1[6*bw-1:5*bw] = K_core1[q][5];
    mem_in_core1[7*bw-1:6*bw] = K_core1[q][6];
    mem_in_core1[8*bw-1:7*bw] = K_core1[q][7];

    mem_in_core2[1*bw-1:0*bw] = K_core2[q][0];
    mem_in_core2[2*bw-1:1*bw] = K_core2[q][1];
    mem_in_core2[3*bw-1:2*bw] = K_core2[q][2];
    mem_in_core2[4*bw-1:3*bw] = K_core2[q][3];
    mem_in_core2[5*bw-1:4*bw] = K_core2[q][4];
    mem_in_core2[6*bw-1:5*bw] = K_core2[q][5];
    mem_in_core2[7*bw-1:6*bw] = K_core2[q][6];
    mem_in_core2[8*bw-1:7*bw] = K_core2[q][7];
    #0.5 clk = 1'b1;  

  end

  #0.5 clk = 1'b0;  
  kmem_even_wr_core1 = 0;
  kmem_even_wr_core2 = 0;  
  qkmem_add_core1 = 0;
  qkmem_add_core2 = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;   
  end




/////  K data loading  /////
$display("##### K data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    
    #0.5 clk = 1'b0;  
    mac_loadk_core1 = 1;
    mac_loadk_core2 = 1; 
    if (q==1) begin 
      kmem_even_rd_core1 = 1;
      kmem_even_rd_core2 = 1;
    end
    if (q>1) begin
       qkmem_add_core1 = qkmem_add_core1 + 1;
       qkmem_add_core2 = qkmem_add_core2 + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  kmem_even_rd_core1 = 0; kmem_even_rd_core2 = 0; qkmem_add_core1 = 0; qkmem_add_core2 = 0;
  #0.5 clk = 1'b1;  

  #0.5 clk = 1'b0;  
  mac_loadk_core1 = 0;
  mac_loadk_core2 = 0; 
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<2* total_cycle +2; q=q+1) begin
    
    #0.5 clk = 1'b0;  
    mac_exe_core1 = 1;
    mac_exe_core2 = 1; 
    qmem_even_rd_core1 = 1;
    qmem_even_rd_core2 = 1;
    if (q>0 && q <8) begin
       qkmem_add_core1 = qkmem_add_core1 + 1;
       qkmem_add_core2 = qkmem_add_core2 + 1;
    end


    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  qmem_even_rd_core1 = 0; 
  qmem_even_rd_core2 = 0; 
  qkmem_add_core1 = 0; 
  qkmem_add_core2 = 0; 
  mac_exe_core1 = 0; 
  mac_exe_core2 = 0;
  #0.5 clk = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    
    #0.5 clk = 1'b0;  
    ofifo_rd_core1 = 1;
    ofifo_rd_core2 = 1; 
    pmem_wr_core1 = 1;
    pmem_wr_core2 = 1; 
    if (q > 0) begin
    pmem_add_core1 = pmem_add_core1 + 1;
    pmem_add_core2 = pmem_add_core2 + 1;
  end
    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  pmem_wr_core1 = 0; pmem_wr_core2 = 0;
  pmem_add_core1 = 0; pmem_add_core2 = 0;
  ofifo_rd_core1 = 0; ofifo_rd_core2 = 0;
  #0.5 clk = 1'b1;  


/////////////////////Verify Multiplication Result////////////////////////////////////

$display("Fectch core1 pmem content");
for (q = 0; q<total_cycle +1; q=q+1) begin
  
  #0.5 clk = 1'b0;
  pmem_rd_core1 = 1;
  if (q>0)
  pmem_add_core1 = pmem_add_core1 + 1;
  #0.5 clk = 1'b1;
  if (q>1) begin
    if(out_core1 == multiplication_result_core1[q-2])
    $display("cycle%d, out is %h, data match :D ", q-1, out_core1);
    else $display("data does not match, error occurs at %1d", q-1);
  end
end

$display("Fectch core2 pmem content");
for (q = 0; q<total_cycle + 2; q=q+1) begin
  #0.5 clk = 1'b0;
  pmem_rd_core2 = 1;
  if (q>0) begin
    pmem_add_core2 = pmem_add_core2 + 1;
  end
  #0.5 clk = 1'b1;
  if (q>1) begin
    if (out_core2 == multiplication_result_core2[q-2])
    $display("cycle%d, out is %h, data match :D", q-1, out_core2);
    else $display("data does not match, error occurs at %1d", q-1);
  end
end // Successful up to this point

pmem_add_core1 = 0; pmem_add_core2 = 0;

$display("##### normalize output #####");

  #0.5 clk = 1'b0;
  pmem_rd_core1 = 1;
  pmem_rd_core2 = 1;
  sfp_acc_core1 = 1; 
  sfp_acc_core2 = 1; 
  #0.5 clk = 1'b1;

  #0.5 clk = 1'b0;

  
  for(q=0; q<total_cycle + 1; q=q+1) begin
    pmem_add_core1 = pmem_add_core1 + 1;
    pmem_add_core2 = pmem_add_core2 + 1;
    #0.5 clk = 1'b1;
    #0.5 clk = 1'b0;
    #0.5 clk = 1'b1;
    #0.5 clk = 1'b0;
    #0.5 clk = 1'b1;
    #0.5 clk = 1'b0;
  end

  sfp_acc_core1 = 0 ; sfp_div_core1 = 0; pmem_add_core1 = 0;
  sfp_acc_core2 = 0 ; sfp_div_core2 = 0; pmem_add_core2 = 0;
  pmem_rd_core1 = 0; pmem_rd_core2 = 0;
  #0.5 clk = 1'b1;

  for (q=0; q<total_cycle + 1;q=q+1) begin // core1 sending data to core2
    #0.5 clk = 1'b0;
    fifo_ext_rd_core1 = 1;
    wr_sum_core2 = 1;
    if (q == 0) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end
    #0.5 clk = 1'b1;
  end

  #0.5 clk = 1'b0;
  fifo_ext_rd_core1 = 0;
  wr_sum_core2 = 0;
  #0.5 clk = 1'b1;

  for (q=0; q<total_cycle + 1;q=q+1) begin // core2 sending data to core1
    #0.5 clk = 1'b0;
    fifo_ext_rd_core2 = 1;
    wr_sum_core1 = 1;
    if (q == 0) begin
      #0.5 clk = 1'b0;
      #0.5 clk = 1'b1;
    end
    #0.5 clk = 1'b1;
  end

  #0.5 clk = 1'b0;
  fifo_ext_rd_core2 = 0;
  wr_sum_core1 = 0;
  norm_mem_addr_core1 = 0;
  norm_mem_addr_core2 = 0;
  #0.5 clk = 1'b1;

   for (q = 0; q< total_cycle +2;q=q+1) begin // move pmem content to ififo in sfp
    #0.5 clk = 1'b0;
    pmem_rd_core1 = 1; pmem_rd_core2 = 1;
    //sfp_div_core1 = 1; sfp_div_core2 = 1;
    sfp_ififo_wr_core1 = 1; sfp_ififo_wr_core2 = 1;
    if (q>0) begin
      pmem_add_core1 = pmem_add_core1 + 1;
      pmem_add_core2 = pmem_add_core2 + 1;
    end
    //if (q> 1) begin
    //$display("core 1: cycle: %1d, expected out is %h, acutal out is %h", q-1, norm_out_col_core1[q-2], out_sfp_core1);
    //$display("core2: cycle %1d, expected out is %h, actual out is %h", q-1, norm_out_col_core2[q-2], out_sfp_core2);
    //end

    //if (q>1) begin
      //norm_mem_wr_core1 = 1; norm_mem_wr_core2 = 1;
      //if (q>2) begin
        //norm_mem_addr_core1 = norm_mem_addr_core1 + 1;
        //norm_mem_addr_core2 = norm_mem_addr_core2 + 1;
      //end
      #0.5 clk = 1'b1;
    end
    


#0.5 clk = 1'b0;
pmem_rd_core1 = 0; pmem_rd_core2 = 0;
sfp_ififo_wr_core1 = 0; sfp_ififo_wr_core2 = 0;
#0.5 clk =1'b1;

  for (i = 0; i < total_cycle + 2; i=i+1) begin
  #0.5 clk = 1'b0;
	sfp_div_core1 = 1; sfp_div_core2 = 1;
	norm_mem_wr_core1 = 1; norm_mem_wr_core2 = 1;
	if (i > 2) begin
		norm_mem_addr_core1 = norm_mem_addr_core1 + 1;
		norm_mem_addr_core2 = norm_mem_addr_core2 + 1;
	end
	#0.5 clk = 1'b1;
  end




  #0.5 clk = 1'b0;
  norm_mem_wr_core1 = 0; norm_mem_wr_core2 = 0;
  norm_mem_addr_core1 = 0; norm_mem_addr_core2 = 0;
    #0.5 clk = 1'b1;


  $display("Fetching norm_mem content to double check");
  for (q=0; q<total_cycle + 3; q=q+1) begin
    #0.5 clk = 1'b0;
    norm_mem_rd_core1 = 1; norm_mem_rd_core2 = 1;
    if (q>1) begin
      norm_mem_addr_core1 = norm_mem_addr_core1 + 1;
      norm_mem_addr_core2 = norm_mem_addr_core2 + 1;
      if (q>2) begin
      if (out_core1 == norm_out_col_core1[q-3] && out_core2 == norm_out_col_core2[q-3]) begin
        $display("For core 1, cycle %1d, expected out is %h, actual out is %h. Data Match :D",q-2, norm_out_col_core1[q-3], out_core1);
        $display("For core 2, cycle %1d, expected out is %h, actual out is %h. Data Match :D",q-2, norm_out_col_core2[q-3], out_core2);
      end
      end
      //else $display("Data does not match, error occurs at cycle %d", q);
      
    end

    
    #0.5 clk = 1'b1;
  end
  
end
endmodule




