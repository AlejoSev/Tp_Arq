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
        input wire i_tx_start,
        input wire i_data,

        output wire [NB_DATA-1:0] o_data,
        output wire o_rx_done_tick,
        output wire o_tx_done_tick);

wire i_s_tick_wire;
wire rx_tx_wire;

rx_uart rx_uart_instance(.i_clock(i_clock),
                         .i_s_tick(i_s_tick_wire),
                         .i_reset(i_reset),
                         .i_rx(rx_tx_wire),
                         .o_rx_done_tick(o_rx_done_tick),
                         .o_data(o_data));

tx_uart tx_uart_instance(.i_clock(i_clock),
                         .i_reset(i_reset),
                         .i_tx_start(i_tx_start),
                         .i_s_tick(i_s_tick_wire),
                         .i_data(i_data),
                         .o_tx_done_tick(o_tx_done_tick),
                         .o_tx(rx_tx_wire));
                            
baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                                .i_reset(i_reset),
                                                .o_br_clock(i_s_tick_wire));

endmodule