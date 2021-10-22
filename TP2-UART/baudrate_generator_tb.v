`timescale 1ns / 1ps

module baudrate_generator_tb;
    parameter NB_COUNT = 8;
    parameter N_TICKS  = 163;

    reg i_clock;
    reg i_reset;
    wire o_br_clock;

    initial begin
        i_reset = 1'b1;
        i_clock = 1'b0;
        
        #20
        i_reset = 1'b0;

        #1002
        $finish;
    end

    always #5 i_clock = ~i_clock;

    baudrate_generator baudrate_generator_instance( .i_clock(i_clock),
                                                    .i_reset(i_reset),
                                                    .o_br_clock(o_br_clock));

endmodule