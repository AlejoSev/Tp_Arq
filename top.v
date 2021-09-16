`timescale 1ns / 1ps

module top
	#(  parameter NB_INPUTS = 8,
        parameter NB_OUTPUTS = 8,
		parameter NB_OP = 6)
	(   input wire                      i_clock,
        input wire                      i_reset,
        input wire  [2:0]               i_buttons,
        input wire  signed [NB_INPUTS-1:0]     i_switches,
        output wire signed [NB_OUTPUTS-1:0]    o_leds);

wire [NB_INPUTS-1:0] data_a;
wire [NB_INPUTS-1:0] data_b;
wire [NB_OP-1:0]	 operation;

values_load values_load_instance1(	.i_clock(i_clock),
									.i_reset(i_reset),
									.i_buttons(i_buttons),
									.i_switches(i_switches),
									.o_data_a(data_a),
									.o_data_b(data_b),
									.o_operation(operation));

alu alu_instance1(	.i_data_a(data_a),
					.i_data_b(data_b),
					.i_operation(operation),
					.o_result(o_leds));

endmodule