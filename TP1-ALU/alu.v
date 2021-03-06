`timescale 1ns / 1ps

module alu
	#(	parameter NB_INPUTS = 8,
		parameter NB_OUTPUTS = 8,
		parameter NB_OP = 6)
	(	input wire signed [NB_INPUTS-1:0]	i_data_a,
		input wire signed [NB_INPUTS-1:0]	i_data_b,
		input wire [NB_OP-1:0]		i_operation,
		output reg signed [NB_OUTPUTS-1:0]	o_result);

always@(*)begin
	if(i_operation == 32)begin:_add
		o_result = i_data_a + i_data_b;
	end
	else if(i_operation == 34)begin:_sub
		o_result = i_data_a - i_data_b;
	end
	else if(i_operation == 36)begin:_and
		o_result = i_data_a & i_data_b;
	end
	else if(i_operation == 37)begin:_or
		o_result = i_data_a | i_data_b;
	end
	else if(i_operation == 38)begin:_xor
		o_result = i_data_a ^ i_data_b;
	end
	else if(i_operation == 3)begin:_sra
		o_result = i_data_a >>> i_data_b;
	end
	else if(i_operation == 4)begin:_srl
		o_result = i_data_a >> i_data_b;
	end
	else if(i_operation == 39)begin:_nor
		o_result = ~(i_data_a | i_data_b);
	end
	else begin
	   o_result = 0;
	end
end

endmodule