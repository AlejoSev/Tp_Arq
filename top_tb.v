`timescale 1ns / 1ps

module tb_alu;
    parameter NB_INPUTS = 8;
    parameter NB_OUTPUTS = 8;
    parameter NB_OP = 6;

    reg                     clock;
    reg                     reset;
    reg  [2:0]              buttons;
    reg  [NB_INPUTS-1:0]    switches;
    wire [NB_OUTPUTS-1:0]   leds;

    initial begin
        clock = 0;
        reset = 0;
        switches = 8'd1;
        buttons = 3'd0;
        
        #10
        buttons = 3'd1; //Carga data_a
        #10
        buttons = 3'd2; //Carga data_b
        #10
        switches = 6'b100000; //Add
        buttons = 3'd4; //Carga operation
        
        #10
        $finish;
    end

    always #5 clock = ~clock;

    top top_instance(   .i_clock(clock), 
                        .i_reset(reset),
                        .i_buttons(buttons),
                        .i_switches(switches),
                        .o_leds(leds));

endmodule