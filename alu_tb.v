`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2021 08:54:10 PM
// Design Name: 
// Module Name: alu_tb
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

module tb_alu;
    parameter NB_INPUTS = 8;
    parameter NB_OUTPUTS = 8;
    parameter NB_OP = 6;

    reg [NB_INPUTS-1:0]     dato_a;
    reg [NB_INPUTS-1:0]     dato_b;
    reg [NB_OP-1:0]         operation;
    wire [NB_OUTPUTS-1:0]   result;

    initial begin
        dato_a = 1;
        dato_b = 1;
        operation = 6'b100000;

        #10
        operation = 6'b100010;

        #10
        operation = 6'b100100;

        #10
        operation = 6'b100101;

        #10
        operation = 6'b100110;

        #10
        operation = 6'b100111;

        #10
        $finish;
    end

    alu alu_instance(.i_dato_a(dato_a), .i_dato_b(dato_b), .i_operation(operation), .o_result(result));

endmodule
