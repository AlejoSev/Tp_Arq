`timescale 1ns / 1ps

module rx_uart
    #(parameter NB_STATE = 2,
      parameter NB_COUNT = 4,
      parameter NB_DATA  = 3)
      parameter N_STOP  = 2; //cantidad de bits de stop SB_TICK
    (input wire i_clock, // clock del baudrate generator
     input wire i_reset,
     input wire i_rx,
     output wire rx_done_tick
    );

localparam [NB_STATE - 1:0] STATE_WAIT    = 2'd0 ;
localparam [NB_STATE - 1:0] STATE_START   = 2'd1 ;
localparam [NB_STATE - 1:0] STATE_PHASE   = 2'd2 ;
localparam [NB_STATE - 1:0] STATE_RECEIVE = 2'd3 ;
localparam [NB_STATE - 1:0] STATE_STOP    = 2'd4 ;
localparam [NB_COUNT - 1:0] MID_STOP      = 4'd7 ;
localparam [NB_COUNT - 1:0] END_STOP      = 4'd15;

reg [NB_STATE - 1:0] state ;
reg [NB_STATE - 1:0] next state;
reg [NB_COUNT - 1:0] tick_counter; //s
reg [NB_DATA  - 1:0] data_counter;

always @(*) begin: next_state_logic
    case (state)
        STATE_WAIT: begin
            case (i_rx)
                1'b0: 
                    next_state = STATE_START;
                default: 
                    next_state = STATE_WAIT;
            endcase
        end
        STATE_START: begin
            case (tick_counter)
                MID_STOP: 
                    next_state = STATE_PHASE;
                default:
                    next_state = STATE_START;
            endcase
        end
        STATE_PHASE: begin
            case (tick_counter)
                END_STOP:
                    next_state = STATE_RECEIVE; 
                default:
                    next_state = STATE_PHASE;
            endcase
        end
        STATE_RECEIVE: begin
            case (data_counter)
                3'd8:
                    next_state = STATE_STOP;
                default: 
                    next_state = STATE_PHASE;
            endcase
        end
        STATE_STOP: begin 
            case (tick_counter) //preguntar !!!!!!!!!!
                N_STOP:
                    next_state = STATE_WAIT;
                default: 
                    next_state = STATE_STOP;
            endcase
        end
        default:
            next_state = STATE_WAIT; //preguntar
    endcase
end

always @(posedge i_clock)begin
    if(i_reset)
        state <= STATE_WAIT;
    else 
        state <= next_state;
end


endmodule