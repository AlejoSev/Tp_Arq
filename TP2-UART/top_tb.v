`timescale 1ns / 1ps

module top_tb;
    parameter DBIT      = 8;
    parameter NB_STATE  = 2;
    parameter SB_TICK   = 16;

    reg i_clock; // clock del baudrate generator
    reg i_reset;
    reg i_tx_start;
    reg [DBIT-1:0] i_data;

    wire o_tx;
    // wire [DBIT-1:0] o_result_test;
    // wire [DBIT-1:0] o_dataA_test;
    // wire [DBIT-1:0] o_dataB_test;
    // wire [DBIT-1:0] o_op_test;
    // wire [DBIT-1:0] o_data_rx_interface_test;

    wire i_s_tick_wire;
    wire o_data_to_top;

//wire [DBIT-1:0] tb_alu_result;
//assign tb_alu_result = top_tb.top_instance.rx_uart_instance.shiftreg;


    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;


        //DATO A = 85
        #1000
        i_data = 8'b01010101;

        #100
        i_tx_start = 1'b1;
        #1000
        i_reset = 1'b0;
        #100
        i_tx_start = 1'b0;

        //DATO B = 1
        #540000
        i_data = 8'b00000001;
        #1000
        i_tx_start = 1'b1;
        #100
        i_tx_start = 1'b0;
        
        //OPCODE = ADD
        #540000
        i_data = 8'd32;
        #1000
        i_tx_start = 1'b1;
        #100
        i_tx_start = 1'b0;

        #600000
        $finish;
    end

    always #10 i_clock = ~i_clock;

    baudrate_generator baudrate_generator_test_instance(.i_clock(i_clock),
                                                .i_reset(i_reset),
                                                .o_br_clock(i_s_tick_wire)); 

    tx_uart tx_uart_test_instance(.i_clock(i_clock),
                            .i_reset(i_reset),
                            .i_tx_start(i_tx_start),
                            .i_s_tick(i_s_tick_wire),
                            .i_data(i_data),
                            .o_tx_done_tick(o_tx_done_tick),
                            .o_tx(o_data_to_top));

    top top_instance(.i_clock(i_clock),
                     .i_reset(i_reset),
                     .i_data_rx(o_data_to_top),
                     .o_tx(o_tx)
                    //  .o_result_test(o_result_test),
                    //  .o_dataA_test(o_dataA_test),
                    //  .o_dataB_test(o_dataB_test),
                    //  .o_op_test(o_data_test),
                    //  .o_data_rx_interface_test(o_data_rx_interface_test)
                    );

endmodule