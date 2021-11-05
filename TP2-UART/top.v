`timescale 1ns / 1ps

module top
	#( parameter NB_INPUTS  = 8,
           parameter NB_OUTPUTS = 8,
           parameter NB_DATA    = 8,
	   parameter NB_OP      = 6
           )
	(
        input wire                      i_clock,
        input wire                      i_reset,
        input wire                      i_rx,
        output wire [NB_DATA-1:0] o_data,
        output wire o_rx_done_tick);

wire i_s_tick_wire;


rx_uart rx_uart_instance(.i_clock(i_clock),
                            .i_s_tick(i_s_tick_wire),
                            .i_reset(i_reset),
                            .i_rx(i_rx),
                            .o_rx_done_tick(o_rx_done_tick),
                            .o_data(o_data));
                            
baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                                .i_reset(i_reset),
                                                .o_br_clock(i_s_tick_wire));

endmodule