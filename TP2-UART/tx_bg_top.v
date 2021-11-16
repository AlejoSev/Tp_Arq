`timescale 1ns / 1ps

module tx_bg_top
      #(parameter NB_DATA = 8)
       (input wire  i_clock,
        input wire  i_reset,
        input wire  i_tx_start,
        input wire  [NB_DATA-1:0] i_data,
        output wire o_tx_done_tick,
        output wire o_tx);

wire i_s_tick_wire;

tx_uart tx_uart_instance(.i_clock(i_clock),
                         .i_reset(i_reset),
                         .i_tx_start(i_tx_start),
                         .i_s_tick(i_s_tick_wire),
                         .i_data(i_data),
                         .o_tx_done_tick(o_tx_done_tick),
                         .o_tx(o_tx));
                            
baudrate_generator baudrate_generator_instance(.i_clock(i_clock),
                                               .i_reset(i_reset),
                                               .o_br_clock(i_s_tick_wire));

endmodule