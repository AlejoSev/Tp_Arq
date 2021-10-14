`timescale 1ns / 1ps

module baudrate_generator_tb;
    parameter NB_STATE      = 2;
    parameter NB_COUNT      = 4;
    parameter NB_DATA_COUNT = 3;
    parameter NB_DATA       = 8;
    parameter N_STOP        = 2;

    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_rx;
    wire rx_done_tick;
    wire [NB_DATA-1:0] o_data;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;
        i_rx    = 1'b1;
        
        #10
        i_reset = 1'b0;

        #50
        i_rx    = 1'b0; //start bit

        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b0;
        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b0;
        #10
        i_rx    = 1'b1;
        #10
        i_rx    = 1'b1; //stop bit1
        #10
        i_rx    = 1'b1; //stop bit2

        #10
        i_rx    = 1'b1;

        #10
        i_rx    = 1'b1;

        #1000
        $finish;
    end

    always #5 i_clock = ~i_clock;

    rx_uart rx_uart_instance(.i_clock(i_clock),
                             .i_reset(i_reset),
                             .i_rx(i_rx),
                             .rx_done_tick(rx_done_tick),
                             .o_data(o_data));

endmodule