`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2026 10:46:15
// Design Name: 
// Module Name: uart_top
// Project Name: 
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


module uart_top(

    input rst,
    input clk,

    input wr_en,
    input [7:0] data_in,

    input rdy_clr,

    output rdy,
    output busy,

    output [7:0] data_out

);

wire tx_clk_en;
wire rx_clk_en;

wire tx;


//------------------------------------------------------------
// BAUD GENERATOR
//------------------------------------------------------------

baudrate_gen bg(

    .clock(clk),
    .reset(rst),

    .enb_tx(tx_clk_en),
    .enb_rx(rx_clk_en)

);


//------------------------------------------------------------
// TRANSMITTER
//------------------------------------------------------------

transmitter_tx tx_mod(

    .clk(clk),
    .wr_en(wr_en),
    .enb(tx_clk_en),
    .rst(rst),

    .data_in(data_in),

    .tx(tx),
    .tx_busy(busy)

);


//------------------------------------------------------------
// RECEIVER
//------------------------------------------------------------

receiver_rx rx_mod(

    .clk(clk),
    .rst(rst),

    .rx(tx),

    .rdy_clr(rdy_clr),

    .clken(rx_clk_en),

    .rdy(rdy),

    .data_out(data_out)

);

endmodule
