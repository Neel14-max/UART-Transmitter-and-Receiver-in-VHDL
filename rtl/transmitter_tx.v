`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2026 10:43:55
// Design Name: 
// Module Name: transmitter_tx
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



// UART TRANSMITTER
//============================================================

module transmitter_tx(

    input clk,
    input wr_en,
    input enb,
    input rst,

    input [7:0] data_in,

    output reg tx,
    output tx_busy

);

parameter STATE_IDLE  = 2'b00;
parameter STATE_START = 2'b01;
parameter STATE_DATA  = 2'b10;
parameter STATE_STOP  = 2'b11;

reg [7:0] data;
reg [2:0] bitpos;
reg [1:0] state;


always @(posedge clk)
begin

    if(rst)
    begin

        tx <= 1'b1;

        state <= STATE_IDLE;

        bitpos <= 0;
        data <= 0;

    end

    else
    begin

        case(state)

            //------------------------------------------------
            // IDLE
            //------------------------------------------------

            STATE_IDLE:
            begin

                tx <= 1'b1;

                if(wr_en)
                begin

                    data <= data_in;

                    bitpos <= 0;

                    state <= STATE_START;

                end

            end


            //------------------------------------------------
            // START BIT
            //------------------------------------------------

            STATE_START:
            begin

                if(enb)
                begin

                    tx <= 1'b0;

                    state <= STATE_DATA;

                end

            end


            //------------------------------------------------
            // DATA BITS
            //------------------------------------------------

            STATE_DATA:
            begin

                if(enb)
                begin

                    tx <= data[bitpos];

                    if(bitpos == 7)
                    begin

                        bitpos <= 0;

                        state <= STATE_STOP;

                    end

                    else
                    begin

                        bitpos <= bitpos + 1'b1;

                    end

                end

            end


            //------------------------------------------------
            // STOP BIT
            //------------------------------------------------

            STATE_STOP:
            begin

                if(enb)
                begin

                    tx <= 1'b1;

                    state <= STATE_IDLE;

                end

            end


            //------------------------------------------------
            // DEFAULT
            //------------------------------------------------

            default:
            begin

                tx <= 1'b1;

                state <= STATE_IDLE;

            end

        endcase

    end

end


assign tx_busy = (state != STATE_IDLE);

endmodule
