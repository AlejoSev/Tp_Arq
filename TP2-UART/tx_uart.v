`timescale 1ns / 1ps

module tx_uart
    #(parameter NB_STATE        = 3,
      parameter NB_COUNT        = 5,
      parameter NB_DATA_COUNT   = 4,
      parameter NB_DATA         = 8,
      parameter N_TICKS_TO_STOP = 30) //Cant. bits de stop * tick por bit (2 * 15)
    (input wire i_clock,
     input wire i_reset,
     input wire i_tx_start,
     input wire [NB_DATA-1:0] din,
     output wire o_tx_done_tick,
     output wire o_tx);

localparam [NB_STATE - 1:0] STATE_WAIT    = 3'd0 ;
localparam [NB_STATE - 1:0] STATE_START   = 3'd1 ;
localparam [NB_STATE - 1:0] STATE_PHASE   = 3'd2 ;
localparam [NB_STATE - 1:0] STATE_RECEIVE = 3'd3 ;
localparam [NB_STATE - 1:0] STATE_STOP    = 3'd4 ;
localparam [NB_COUNT - 1:0] MID_STOP      = 4'd7 ;
localparam [NB_COUNT - 1:0] END_STOP      = 4'd15;

reg [NB_STATE      - 1:0] state;
reg [NB_STATE      - 1:0] next_state;
reg [NB_DATA_COUNT - 1:0] data_counter;
reg                       tx_done_tick;
reg                       tx;   

always @(posedge i_clock)begin
    if(i_reset) begin
        state <= STATE_WAIT;
        tx_done_tick <= 1'b0;
        data_counter <= {NB_DATA_COUNT{1'b0}};
    end
    else
        state <= next_state;

    case (state)
        STATE_WAIT: begin
            data_counter <= {NB_DATA_COUNT{1'b0}};
            tx_done_tick <= 1'b0;
        end 
        STATE_START: begin
            case (tick_counter)
                MID_STOP: begin
                    tick_counter <= {NB_COUNT{1'b0}};
                    data_counter <= {NB_DATA_COUNT{1'b0}};
                end
                default:
                    tick_counter <= tick_counter + 1;
            endcase
        end
        STATE_PHASE: begin
            case (tick_counter)
                END_STOP: begin
                    tick_counter <= {NB_COUNT{1'b0}};
                    shiftreg <= {i_rx, shiftreg[NB_DATA-1:1]};
                end
                default:
                    tick_counter <= tick_counter + 1;
            endcase
        end
        STATE_RECEIVE: begin
            if (data_counter < NB_DATA) begin
                data_counter <= data_counter + 1;
            end   
        end
        STATE_STOP: begin
            case (tick_counter)
                N_TICKS_TO_STOP:
                    rx_done_tick <= 1'b1; 
                default:
                    tick_counter <= tick_counter + 1;
            endcase
        end
    endcase
end

always @(*) begin: next_state_logic
    case (state)
        STATE_WAIT: begin
            case (i_rx)
                1'b0:
                    next_state   = STATE_START;
                default: 
                    next_state = STATE_WAIT;
            endcase
        end
        STATE_START: begin
            case (tick_counter)
                MID_STOP:
                    next_state   = STATE_PHASE;
                default:
                    next_state   = STATE_START;
            endcase
        end
        STATE_PHASE: begin
            case (tick_counter)
                END_STOP:
                    next_state   = STATE_RECEIVE;
                default:
                    next_state   = STATE_PHASE;
            endcase
        end
        STATE_RECEIVE: begin
            case (data_counter)
                NB_DATA-1:
                    next_state = STATE_STOP;
                default:
                    next_state   = STATE_PHASE;
            endcase
        end
        STATE_STOP: begin 
            case (tick_counter)
                N_TICKS_TO_STOP:
                    next_state = STATE_WAIT;
                default:
                    next_state = STATE_STOP;
            endcase
        end
    endcase
end

assign o_tx_done_tick = tx_done_tick;
assign o_tx           = tx;

endmodule