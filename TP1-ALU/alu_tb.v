`timescale 1ns / 1ps

module alu_tb;
    parameter NB_INPUTS = 8;
    parameter NB_OUTPUTS = 8;
    parameter NB_OP = 6;

    reg signed [NB_INPUTS-1:0]     data_a;
    reg signed [NB_INPUTS-1:0]     data_b;
    reg [NB_OP-1:0]                operation;
    wire signed [NB_OUTPUTS-1:0]   result;

    initial begin
        data_a = 1;
        data_b = 1;
        operation = 6'b100000; //ADD

        #10
        operation = 6'b100010; //SUB

        #10
        operation = 6'b100100; //AND

        #10
        operation = 6'b100101; //OR

        #10
        operation = 6'b100110; //XOR

        #10
        operation = 6'b100111; //NOR

        #10
        operation = 6'b000011; //SRA

        #10
        operation = 6'b000010; //SRL

        #10
        $finish;
    end

    alu alu_instance(   .i_data_a(data_a),
                        .i_data_b(data_b),
                        .i_operation(operation), 
                        .o_result(result));

endmodule
