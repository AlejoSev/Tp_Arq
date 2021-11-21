`timescale 1ns / 1ps

module UART
		#(parameter NB_DATA = 8,
		  parameter NB_OP =6)
		(
		input wire i_clock,
		input wire i_reset,
		input wire i_result, //from ALU
		input wire i_rx,
		output wire o_tx,
		output wire o_tx_done_tick,
		output wire [NB_DATA - 1 : 0] o_data_A,
		output wire [NB_DATA - 1 : 0] o_data_B,
		output wire [NB_OP - 1 : 0] o_operation
		);

wire s_tick_wire;
wire rx_done_tick_wire;
wire [NB_DATA - 1 : 0] data_wire;
wire transmit_wire; //tx valid to start transmision

baudrate_generator bg_instance(.i_clock(i_clock),
                               .i_reset(i_reset),
                               .o_br_clock(s_tick_wire));

rx_uart rx_uart_instance(.i_clock(i_clock),
                         .i_s_tick(s_tick_wire),
                         .i_reset(i_reset),
                         .i_rx(i_rx),
                         .o_rx_done_tick(rx_done_tick_wire),
                         .o_data(data_wire));

interface interface_instance(.i_clock(i_clock),
                             .i_reset(i_reset),
                             .i_valid(rx_done_tick_wire),
                             .i_data(data_wire),
                             .o_data_a(o_data_A),
                             .o_data_b(o_data_B),
                             .o_operation(o_operation),
                             .o_transmit(transmit_wire));

tx_uart tx_uart_instance_2(.i_clock(i_clock),
                           .i_reset(i_reset),
                           .i_tx_start(transmit_wire),
                           .i_s_tick(s_tick_wire),
                           .i_data(i_result),
                           .o_tx_done_tick(o_tx_done_tick),
                           .o_tx(o_tx));    

endmodule