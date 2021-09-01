module alu
	#(	parameter NB_INPUTS = 8,
		parameter NB_OUTPUTS = 8,
		parameter NB_OP = 6)
	(	input wire [NB_INPUTS-1:0]	i_dato_a,
		input wire [NB_INPUTS-1:0]	i_dato_b,
		input wire [NB_OP-1:0]		i_operation,
		output wire [NB_OUTPUTS-1:0]	o_result);

reg result[NB_OUTPUTS-1:0];

always@(*)begin
	if(i_operation == NB_OP'b100000)begin:_add
		result = i_dato_a + i_dato_b;
	end
	else if(i_operation == NB_OP'100010)begin:_sub
		result = i_dato_a - i_dato_b;
	end
	else if(i_operation == NB_OP'100100)begin:_and
		result = i_dato_a & i_dato_b;
	end
	else if(i_operation == NB_OP'100101)begin:_or
		result = i_dato_a | i_dato_b;
	end
	else if(i_operation == NB_OP'100110)begin:_xor
		result = i_dato_a ^ i_dato_b;
	end
	else if(i_operation == NB_OP'000011)begin:_sra
		result = NB_OUTPUTS'b0;
	end
	else if(i_operation == NB_OP'000010)begin:_srl
		result = NB_OUTPUTS'b0;
	end
	else if(i_operation == NB_OP'100111)begin:_nor
		result = ~(i_dato_a | i_dato_b);
	end
end

assign o_result = result;