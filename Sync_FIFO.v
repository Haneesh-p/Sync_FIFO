`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: P.Haneesh
// 
// Create Date: 19.05.2026 16:53:19
// Design Name: Synchronous fifo
// Module Name: Sync_FIFO
// Project Name: RTL to GDS of synchronus fifo
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sync_FIFO( clk, rst, wr_en, rd_en, full,empty, din,dout );
input clk, rst, wr_en, rd_en;
output full, empty;
parameter data_width=8, depth=16, add_width=4;
input [data_width-1:0] din;
output reg [data_width-1:0] dout;

reg [data_width-1:0] mem [0:depth-1];
reg [add_width:0] wr_ptr, rd_ptr;

assign empty = (wr_ptr==rd_ptr);
assign full= (wr_ptr[add_width]!=rd_ptr[add_width])&& (wr_ptr[add_width-1:0]==rd_ptr[add_width-1:0]);

always@(posedge clk)
begin
    if(~rst)
        wr_ptr<=0;
    else if(wr_en && !full)
    begin
        mem[wr_ptr[add_width-1:0]] <= din;
        wr_ptr = wr_ptr+1;
    end
end

always@(posedge clk)
begin
    if(~rst)
    begin
        rd_ptr <= 0;
        dout <= 0;
    end
    else if( rd_en && !empty)
    begin
        dout <= mem[rd_ptr[add_width-1:0]];
        rd_ptr = rd_ptr+1;
    end
end
endmodule
