`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2026 10:42:34
// Design Name: 
// Module Name: baudrate_gen
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


//============================================================
// UART BAUD RATE GENERATOR
//============================================================

module baudrate_gen(

    input clock,
    input reset,

    output reg enb_tx,
    output reg enb_rx

);

parameter clk_freq  = 160;
parameter baud_rate = 10;

localparam integer divisor_tx = clk_freq / baud_rate;
localparam integer divisor_rx = clk_freq / (16 * baud_rate);

reg [31:0] counter_tx;
reg [31:0] counter_rx;


//------------------------------------------------------------
// TX ENABLE GENERATION
//------------------------------------------------------------

always @(posedge clock)
begin

    if(reset)
    begin
        counter_tx <= 0;
        enb_tx <= 0;
    end

    else
    begin

        if(counter_tx == divisor_tx - 1)
        begin
            counter_tx <= 0;
            enb_tx <= 1'b1;
        end

        else
        begin
            counter_tx <= counter_tx + 1'b1;
            enb_tx <= 1'b0;
        end

    end

end


//------------------------------------------------------------
// RX ENABLE GENERATION
//------------------------------------------------------------

always @(posedge clock)
begin

    if(reset)
    begin
        counter_rx <= 0;
        enb_rx <= 0;
    end

    else
    begin

        if(counter_rx == divisor_rx - 1)
        begin
            counter_rx <= 0;
            enb_rx <= 1'b1;
        end

        else
        begin
            counter_rx <= counter_rx + 1'b1;
            enb_rx <= 1'b0;
        end

    end

end

endmodule
