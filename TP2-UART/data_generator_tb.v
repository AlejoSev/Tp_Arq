`timescale 1ns / 1ps
//mock para generar datos sincronizados con baudrate genertor

module data_generator_tb;

parameter NB_TOTAL_DATA = 11; //stop-bit + 8bit + 2 stop-bit
parameter NB_COUNT = 4;

reg i_s_tick;
reg i_reset;
wire o_data;

initial begin
    i_s_tick = 1'b0;
    i_reset  = 1'b1;

    #100
    i_reset  = 1'b0;

            
    #1000
    $finish;
end

always #10 i_s_tick = ~i_s_tick;
    
data_generator data_generator_instance(.i_s_tick(i_s_tick),
                                       .i_reset(i_reset),
                                       .o_data(o_data));

endmodule