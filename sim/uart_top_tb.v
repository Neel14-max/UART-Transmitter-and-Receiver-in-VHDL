`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2026 10:47:20
// Design Name: 
// Module Name: uart_top_tb
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
// UART TESTBENCH
//============================================================

module uart_top_tb;

reg clk;
reg rst;

reg wr_en;
reg rdy_clr;

reg [7:0] data_in;

wire rdy;
wire busy;

wire [7:0] data_out;


//------------------------------------------------------------
// DUT
//------------------------------------------------------------

uart_top dut(

    .rst(rst),
    .clk(clk),

    .wr_en(wr_en),
    .data_in(data_in),

    .rdy_clr(rdy_clr),

    .rdy(rdy),
    .busy(busy),

    .data_out(data_out)

);


//------------------------------------------------------------
// CLOCK
//------------------------------------------------------------

always #5 clk = ~clk;


//------------------------------------------------------------
// INITIAL
//------------------------------------------------------------

initial
begin

    clk = 0;

    rst = 0;

    wr_en = 0;

    rdy_clr = 0;

    data_in = 0;

end


//------------------------------------------------------------
// SEND BYTE TASK
//------------------------------------------------------------

task send_byte;

input [7:0] din;

begin

    @(negedge clk);

    data_in = din;

    wr_en = 1'b1;

    @(negedge clk);

    wr_en = 1'b0;

end

endtask


//------------------------------------------------------------
// CLEAR READY
//------------------------------------------------------------

task clear_ready;

begin

    @(negedge clk);

    rdy_clr = 1'b1;

    @(negedge clk);

    rdy_clr = 1'b0;

end

endtask


//------------------------------------------------------------
// TEST
//------------------------------------------------------------

initial
begin

    //--------------------------------------------------------
    // RESET
    //--------------------------------------------------------

    @(negedge clk);
    rst = 1'b1;

    @(negedge clk);
    rst = 1'b0;

    //--------------------------------------------------------
    // SEND 0x40
    //--------------------------------------------------------

    send_byte(8'h40);

    wait(rdy == 1);

    #10;

    $display("Time=%0t Received Data = %h", $time, data_out);

    clear_ready();

    //--------------------------------------------------------
    // SEND 0x56
    //--------------------------------------------------------

    send_byte(8'h56);

    wait(rdy == 1);

    #10;

    $display("Time=%0t Received Data = %h", $time, data_out);

    clear_ready();

    //--------------------------------------------------------
    // FINISH
    //--------------------------------------------------------

    #10000;

    $finish;

end

//------------------------------------------------------------
// DEBUG MONITOR
//------------------------------------------------------------

initial
begin
    $monitor("Time=%0t rst=%b wr_en=%b busy=%b rdy=%b data_out=%h",
              $time, rst, wr_en, busy, rdy, data_out);
end
endmodule