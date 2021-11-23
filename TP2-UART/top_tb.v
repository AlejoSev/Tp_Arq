`timescale 1ns / 1ps

module top_tb;
    parameter NB_DATA   = 8;
    parameter NB_STATE  = 2;
    parameter SB_TICK   = 16;

    //uart 
    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_rx;
    wire o_tx;
    wire o_tx_done_tick;

    //test_tx
    reg i_tx_start_test;
    reg [NB_DATA-1:0]i_data_test;
    wire i_s_tick_wire_test;
    wire o_tx_test;



    initial begin
        
        i_reset = 1'b1;
        i_clock = 1'b0;

        //DATO A = 85
        #1000
        i_data_test = 8'b01010101;

        #100
        i_tx_start_test = 1'b1;
        #1000
        i_reset = 1'b0;
        #100
        i_tx_start_test = 1'b0;

        //DATO B = 1
        #540000
        i_data_test = 8'b00000001;
        #1000
        i_tx_start_test = 1'b1;
        #100
        i_tx_start_test = 1'b0;
        
        //OPCODE = ADD
        #540000
        i_data_test = 8'd32;
        #1000
        i_tx_start_test = 1'b1;
        #100
        i_tx_start_test = 1'b0;

        #600000
        $finish;
    end

    always #10 i_clock = ~i_clock;

    // baudrate_generator baudrate_generator_test_instance(.i_clock(i_clock),
    //                                             .i_reset(i_reset),
    //                                             .o_br_clock(i_s_tick_wire)); 

    // tx_uart tx_uart_test_instance(.i_clock(i_clock),
    //                         .i_reset(i_reset),
    //                         .i_tx_start(i_tx_start),
    //                         .i_s_tick(i_s_tick_wire),
    //                         .i_data(i_data),
    //                         .o_tx_done_tick(o_tx_done_tick),
    //                         .o_tx(o_data_to_top));

tx_uart tx_test(.i_clock(i_clock),
                .i_reset(i_reset),
                .i_tx_start(i_tx_start_test),
                .i_s_tick(i_s_tick_wire_test),
                .i_data(i_data_test),
                .o_tx_done_tick(o_tx_done_tick),
                .o_tx(o_tx_test));                       
                            
baudrate_generator bg_test(.i_clock(i_clock),
                           .i_reset(i_reset),
                           .o_br_clock(i_s_tick_wire_test));

top top_instance(.i_clock(i_clock),
                 .i_reset(i_reset),
                 .i_rx(o_tx_test),
                 .o_tx(o_tx),
                 .o_tx_done_tick(o_tx_done_tick)
                );

endmodule