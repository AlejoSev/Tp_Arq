`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2021 08:52:58 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu
	#(	parameter NB_INPUTS = 8,
		parameter NB_OUTPUTS = 8,
		parameter NB_OP = 6)
	(	input wire [NB_INPUTS-1:0]	i_dato_a,
		input wire [NB_INPUTS-1:0]	i_dato_b,
		input wire [NB_OP-1:0]		i_operation,
		output reg [NB_OUTPUTS-1:0]	o_result);



always@(*)begin
	if(i_operation == 32)begin:_add
		o_result = i_dato_a + i_dato_b;
	end
	else if(i_operation == 34)begin:_sub
		o_result = i_dato_a - i_dato_b;
	end
	else if(i_operation == 36)begin:_and
		o_result = i_dato_a & i_dato_b;
	end
	else if(i_operation == 37)begin:_or
		o_result = i_dato_a | i_dato_b;
	end
	else if(i_operation == 38)begin:_xor
		o_result = i_dato_a ^ i_dato_b;
	end
	else if(i_operation == 3)begin:_sra
		o_result = {NB_OP{1'b0}};
	end
	else if(i_operation == 4)begin:_srl
		o_result = {NB_OP{1'b0}};
	end
	else if(i_operation == 39)begin:_nor
		o_result = ~(i_dato_a | i_dato_b);
	end
end

endmodule
