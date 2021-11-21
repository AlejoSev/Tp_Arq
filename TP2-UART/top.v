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
        input wire i_rx,
        output wire o_tx,
        output wire o_tx_done_tick
        );

wire [NB_DATA-1:0] result_wire;
wire [NB_DATA-1:0] o_data_A_wire;
wire [NB_DATA-1:0] o_data_B_wire;
wire [NB_OP-1:0]   o_op_wire;


UART UART_instance(.i_clock(i_clock),
                   .i_reset(i_reset),
                   .i_result(result_wire),
                   .i_rx(i_rx),
                   .o_tx(o_tx),
                   .o_tx_done_tick(o_tx_done_tick),
                   .o_data_A(o_data_A_wire),
                   .o_data_B(o_data_B_wire),
                   .o_operation(o_op_wire));

alu alu_instance(.i_data_a(o_data_A_wire),
                 .i_data_b(o_data_B_wire),
                 .i_operation(o_op_wire),
                 .o_result(result_wire));

endmodule