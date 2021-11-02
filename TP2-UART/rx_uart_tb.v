`timescale 1ns / 1ps

module rx_uart_tb;
    parameter NB_STATE        = 3;
    parameter NB_COUNT        = 4;
    parameter NB_DATA_COUNT   = 4;
    parameter NB_DATA         = 8;
    parameter N_TICKS_TO_STOP = 30;

    reg i_clock; // clock del baudrate generator
    wire i_s_tick;
    reg i_reset;
    reg i_rx;
    wire o_rx_done_tick;
    wire [NB_DATA-1:0] o_data;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;
        i_rx    = 1'b1;
        
        #52083
        i_reset = 1'b0;

        #52083
        i_rx    = 1'b0; //start bit

        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b1; //stop bit1
        #52083
        i_rx    = 1'b1; //stop bit2
        
        #52083
        i_rx    = 1'b0; //start bit

        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b0;
        #52083
        i_rx    = 1'b1;
        #52083
        i_rx    = 1'b1; //stop bit1
        #52083
        i_rx    = 1'b1; //stop bit2

        #52083
        i_rx    = 1'b1;

        #52083
        i_rx    = 1'b1;

        #1000
        $finish;
    end

    always #10 i_clock = ~i_clock;

    rx_uart rx_uart_instance(.i_clock(i_clock),
                             .i_s_tick(i_s_tick),
                             .i_reset(i_reset),
                             .i_rx(i_rx),
                             .o_rx_done_tick(o_rx_done_tick),
                             .o_data(o_data));
                             
    baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                                   .i_reset(i_reset),
                                                   .o_br_clock(i_s_tick));

endmodule