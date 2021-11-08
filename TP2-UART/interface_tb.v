`timescale 1ns / 1ps

module interface_tb;

parameter NB_INPUTS = 8;
parameter NB_OUTPUTS = 8;
parameter NB_OP = 6;
parameter NB_COUNT = 2;


reg i_clock,
reg i_reset,
reg signed [NB_INPUTS-1:0]   i_data;
reg                          i_valid;
wire signed [NB_OUTPUTS-1:0] o_data_a;
wire signed [NB_OUTPUTS-1:0] o_data_b;
wire [NB_OP-1:0]             o_operation;


    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;

        #1000
        i_reset = 1'b0;

        #1000
        i_valid = 1;
        i_data = 8'b11111111;
        #20
        i_valid = 0;

        #1000
        i_valid = 1;
        i_data = 8'b00000001;
        #20
        i_valid = 0;

        #1000
        i_valid = 1;
        i_data = 8'd32; 
        #20
        i_valid = 0;


        #1000
        $finish;
    end

    always #10 i_clock = ~i_clock; // 50MHz

endmodule