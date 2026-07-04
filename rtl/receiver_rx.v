`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2026 10:45:16
// Design Name: 
// Module Name: receiver_rx
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


// UART RECEIVER
//============================================================

module receiver_rx(

    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input clken,

    output reg rdy,
    output reg [7:0] data_out

);

parameter RX_STATE_START = 2'b00;
parameter RX_STATE_DATA  = 2'b01;
parameter RX_STATE_STOP  = 2'b10;

reg [1:0] state;

reg [3:0] sample;
reg [2:0] index;

reg [7:0] temp;


always @(posedge clk)
begin

    if(rst)
    begin

        rdy <= 0;

        data_out <= 0;

        state <= RX_STATE_START;

        sample <= 0;

        index <= 0;

        temp <= 0;

    end

    else
    begin

        if(rdy_clr)
            rdy <= 0;

        if(clken)
        begin

            case(state)

                //------------------------------------------------
                // START BIT DETECTION
                //------------------------------------------------

                RX_STATE_START:
                begin

                    if(rx == 0)
                    begin

                        sample <= sample + 1'b1;

                        if(sample == 15)
                        begin

                            sample <= 0;

                            index <= 0;

                            temp <= 0;

                            state <= RX_STATE_DATA;

                        end

                    end

                    else
                    begin

                        sample <= 0;

                    end

                end


                //------------------------------------------------
                // RECEIVE DATA
                //------------------------------------------------

                RX_STATE_DATA:
begin

    sample <= sample + 1'b1;

    //------------------------------------------------
    // SAMPLE IN MIDDLE OF BIT
    //------------------------------------------------

    if(sample == 7)
    begin

        temp[index] <= rx;

    end


    //------------------------------------------------
    // ONE FULL BIT COMPLETED
    //------------------------------------------------

    if(sample == 15)
    begin

        sample <= 0;

        if(index == 7)
        begin

            state <= RX_STATE_STOP;

        end

        else
        begin

            index <= index + 1'b1;

        end

    end

end

                //------------------------------------------------
                // STOP BIT
                //------------------------------------------------

                RX_STATE_STOP:
                begin

                    sample <= sample + 1'b1;

                    if(sample == 15)
                    begin

                        if(rx == 1'b1)
                        begin

                            data_out <= temp;

                            rdy <= 1'b1;

                        end

                        sample <= 0;

                        state <= RX_STATE_START;

                    end

                end


                //------------------------------------------------
                // DEFAULT
                //------------------------------------------------

                default:
                begin

                    state <= RX_STATE_START;

                end

            endcase

        end

    end

end

endmodule
