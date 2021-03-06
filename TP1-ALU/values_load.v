`timescale 1ns / 1ps

module values_load
	#(  parameter NB_INPUTS = 8,
        parameter NB_OUTPUTS = 8,
        parameter NB_OP = 6)
	(   input wire                  i_clock,
        input wire                  i_reset,
        input wire [2:0]            i_buttons,
        input wire  signed [NB_INPUTS-1:0]  i_switches,
        output wire signed [NB_OUTPUTS-1:0] o_data_a,
        output wire signed [NB_OUTPUTS-1:0] o_data_b,
        output wire [NB_OP-1:0]      o_operation);

reg [NB_OUTPUTS-1:0]    data_a;
reg [NB_OUTPUTS-1:0]    data_b;
reg [NB_OP-1:0]         operation;

always@(posedge i_clock)begin
    if(i_reset)begin
        data_a      <= {NB_OUTPUTS{1'b0}};
        data_b      <= {NB_OUTPUTS{1'b0}};
        operation   <= {NB_OP{1'b0}};
    end
    else begin
        if(i_buttons[0])begin
            data_a <= i_switches;
        end
        if(i_buttons[1])begin
            data_b <= i_switches;
        end
        if(i_buttons[2])begin
            operation <= i_switches[NB_OP-1:0];
        end 
    end
end

assign o_data_a     = data_a;
assign o_data_b     = data_b;
assign o_operation  = operation;

endmodule