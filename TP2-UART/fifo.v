`timescale 1ns / 1ps

module fifo
    #(parameter NB_DATA = 8,
      parameter FIFO_DEPTH = 512,
    )
    (
        input  wire i_done, //rx_done: request a writing
        input  wire i_clock,
        input  wire i_reset,
        input  [NB_DATA - 1 : 0] i_data,
        output [NB_DATA - 1 : 0] o_data,
        output wire o_empty,
        output wire o_full //ver para un request reading
    );
//https://esrd2014.blogspot.com/p/first-in-first-out-buffer.html
localparam NB_COUNT = $clog2(FIFO_DEPTH); //9

integer i;
reg [NB_DATA  - 1 : 0] fifo_reg [FIFO_DEPTH -1 : 0];
reg [NB_COUNT - 1 : 0] counter;
reg [NB_COUNT - 1 : 0] wptr; // head pointer of circular fifo
reg [NB_COUNT - 1 : 0] rptr; // tail pointer of circular fifo

always @(posedge i_clock) begin
    if(i_reset)begin

        counter <= {NB_COUNT{1'b0}};
        for (i=0; i < FIFO_DEPTH; i=i+1) begin
            fifo_reg <= {NB_DATA{1'b0}}; //reset array
        wptr <= {NB_COUNT{1'b0}};
        rptr <= {NB_COUNT{1'b0}};
        
    end
    else begin
        
    end
end

endmodule