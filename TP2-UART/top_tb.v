`timescale 1ns / 1ps

module top_tb;
    parameter DBIT      = 8;
    parameter NB_STATE  = 2;
    parameter SB_TICK   = 16;

    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_tx_start;
    reg [DBIT-1:0] i_data;

    wire [DBIT-1:0] o_result;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;

        #1000
        i_reset = 1'b0;

        #1000
        i_data = 8'b01010101;
        #100
        i_tx_start = 1'b1;
        #100
        i_tx_start = 1'b0;

        #540000
        i_data = 8'b00000001;
        #100
        i_tx_start = 1'b1;
        #100
        i_tx_start = 1'b0;

        #540000
        i_data = 8'd32;
        #100
        i_tx_start = 1'b1;
        #100
        i_tx_start = 1'b0;

        #600000
        $finish;
    end

    always #10 i_clock = ~i_clock;

    top top_instance(.i_clock(i_clock),
                     .i_reset(i_reset),
                     .i_tx_start(i_tx_start),
                     .i_data(i_data),
                     .o_result(o_result));

endmodule