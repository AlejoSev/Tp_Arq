`timescale 1ns / 1ps

module tx_uart_tb;
    parameter DBIT      = 8;
    parameter NB_STATE  = 2;
    parameter SB_TICK   = 16;

    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_tx_start;
    reg [DBIT-1:0] i_data;
    wire o_tx_done_tick;
    wire o_tx;

    wire i_s_tick_wire;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;

        #1000
        i_reset = 1'b0;

        #1000
        i_data = 8'b10101010;
        i_tx_start = 1'b1;
        
        #40000
        i_tx_start = 1'b0;

        #1000
        $finish;
    end

    always #10 i_clock = ~i_clock;

    tx_uart tx_uart_instance(.i_clock(i_clock),
                             .i_reset(i_reset),
                             .i_tx_start(i_tx_start),
                             .i_s_tick(i_s_tick_wire),
                             .i_data(i_data),
                             .o_tx_done_tick(o_tx_done_tick),
                             .o_tx(o_tx));

    baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                                   .i_reset(i_reset),
                                                   .o_br_clock(i_s_tick_wire));

endmodule