`timescale 1ns / 1ps

module top
	#( parameter NB_INPUTS  = 8,
           parameter NB_OUTPUTS = 8,
           parameter NB_DATA    = 8,
	   parameter NB_OP      = 6
           )
	(
        input wire i_clock,
        input wire i_reset,
        input wire i_data_rx,
        // output wire[NB_DATA-1:0] o_result_test,
        // output wire[NB_DATA-1:0] o_dataA_test,
        // output wire[NB_DATA-1:0] o_dataB_test,
        // output wire[NB_DATA-1:0] o_op_test,
        // output wire[NB_DATA-1:0] o_data_rx_interface_test,
        output wire o_tx);

wire i_s_tick_wire;
wire o_tx_done_tick;
wire o_rx_done_tick;
wire o_transmit;

wire [NB_DATA-1:0] o_data;
wire [NB_DATA-1:0] o_data_a;
wire [NB_DATA-1:0] o_data_b;
wire [NB_OP-1:0]   o_operation;
wire [NB_DATA-1:0] o_result;

assign o_result_test = o_result;
assign o_dataA_test = o_data_a;
assign o_dataB_test = o_data_b;
assign o_op_test = o_operation;


rx_uart rx_uart_instance(.i_clock(i_clock),
                         .i_s_tick(i_s_tick_wire),
                         .i_reset(i_reset),
                         .i_rx(i_data_rx),
                         .o_rx_done_tick(o_rx_done_tick),
                         .o_data(o_data));


tx_uart tx_uart_instance_2(.i_clock(i_clock),
                         .i_reset(i_reset),
                         .i_tx_start(o_transmit),
                         .i_s_tick(i_s_tick_wire),
                         .i_data(o_result),
                         .o_tx_done_tick(o_tx_done_tick),
                         .o_tx(o_tx));                       
                            
baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                                .i_reset(i_reset),
                                                .o_br_clock(i_s_tick_wire));

interface interface_instance(.i_clock(i_clock),
                             .i_reset(i_reset),
                             .i_valid(o_rx_done_tick),
                             .i_data(o_data),
                             .o_data_a(o_data_a),
                             .o_data_b(o_data_b),
                             .o_operation(o_operation),
                             .o_transmit(o_transmit));

alu alu_instance(.i_data_a(o_data_a),
                 .i_data_b(o_data_b),
                 .i_operation(o_operation),
                 .o_result(o_result));

endmodule