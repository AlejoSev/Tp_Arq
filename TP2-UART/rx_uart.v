`timescale 1ns / 1ps

module rx_uart
    #(parameter NB_STATE = 2)
    (input wire i_clock,
     input
    );

localparam [NB_STATE - 1:0] STATE_WAIT    = 2'd0 ;
localparam [NB_STATE - 1:0] STATE_START   = 2'd1 ;
localparam [NB_STATE - 1:0] STATE_PHASE   = 2'd2 ;
localparam [NB_STATE - 1:0] STATE_RECEIVE = 2'd3 ;
localparam [NB_STATE - 1:0] STATE_STOP    = 2'd4 ;

reg [NB_STATE - 1:0] state ;
reg [NB_STATE - 1:0] next state ;

always @(*) begin: next_state_logic
    case (state)
        STATE_WAIT: begin
        end
        STATE_START: begin
        end
        STATE_PHASE: begin
        end
        STATE_RECEIVE: begin 
        end
        STATE_STOP: begin
        end
        default: 
    endcase
end

endmodule