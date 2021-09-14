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

    reg                     clock;
    reg                     reset;
    reg  [2:0]              buttons;
    reg  [NB_INPUTS-1:0]    switches;
    wire [NB_OUTPUTS-1:0]   data_a;
    wire [NB_OUTPUTS-1:0]   data_b;
    wire [NB_OP-1:0]        operation;

    initial begin
        clock = 0;
        reset = 0;
        switches = 8'b11111111;
        buttons = 3'd0;
        
        #10
        buttons = 3'd1; //Carga data_a
        #10
        buttons = 3'd2; //Carga data_b
        #10
        buttons = 3'd4; //Carga operation
        #10
        reset = 1;
        #10
        $finish;
    end

    always #5 clock = ~clock;

    values_load values_load_instance(   .i_clock(clock), 
                                        .i_reset(reset),
                                        .i_buttons(buttons),
                                        .i_switches(switches),
                                        .o_data_a(data_a),
                                        .o_data_b(data_b),
                                        .o_operation(operation));

endmodule