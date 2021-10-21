`timescale 1ns / 1ps

module rx_uart_tb;
    parameter NB_STATE        = 3;
    parameter NB_COUNT        = 4;
    parameter NB_DATA_COUNT   = 4;
    parameter NB_DATA         = 8;
    parameter N_TICKS_TO_STOP = 30;

    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_rx;
    wire o_rx_done_tick;
    wire [NB_DATA-1:0] o_data;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;
        i_rx    = 1'b1;
        
        #10
        i_reset = 1'b0;

        #50
        i_rx    = 1'b0; //start bit

        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b1; //stop bit1
        #160
        i_rx    = 1'b1; //stop bit2
        
        #160
        i_rx    = 1'b0; //start bit

        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b0;
        #160
        i_rx    = 1'b1;
        #160
        i_rx    = 1'b1; //stop bit1
        #160
        i_rx    = 1'b1; //stop bit2

        #160
        i_rx    = 1'b1;

        #160
        i_rx    = 1'b1;

        #1000
        $finish;
    end

    always #5 i_clock = ~i_clock;

    rx_uart rx_uart_instance(.i_clock(i_clock),
                             .i_reset(i_reset),
                             .i_rx(i_rx),
                             .o_rx_done_tick(o_rx_done_tick),
                             .o_data(o_data));

endmodule