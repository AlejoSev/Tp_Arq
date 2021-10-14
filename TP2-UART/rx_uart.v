`timescale 1ns / 1ps

module rx_uart
    #(parameter NB_STATE      = 3,
      parameter NB_COUNT      = 4,
      parameter NB_DATA_COUNT = 3,
      parameter NB_DATA       = 8,
      parameter N_STOP        = 2) //cantidad de bits de stop SB_TICK
    (input wire i_clock, // clock del baudrate generator
     input wire i_reset,
     input wire i_rx,
     output wire rx_done_tick,
     output wire [NB_DATA-1:0] o_data);

localparam [NB_STATE - 1:0] STATE_WAIT    = 3'd0 ;
localparam [NB_STATE - 1:0] STATE_START   = 3'd1 ;
localparam [NB_STATE - 1:0] STATE_PHASE   = 3'd2 ;
localparam [NB_STATE - 1:0] STATE_RECEIVE = 3'd3 ;
localparam [NB_STATE - 1:0] STATE_STOP    = 3'd4 ;
localparam [NB_COUNT - 1:0] MID_STOP      = 4'd7 ;
localparam [NB_COUNT - 1:0] END_STOP      = 4'd15;

reg [NB_STATE - 1:0] state;
reg [NB_STATE - 1:0] next state;
reg [NB_COUNT - 1:0] tick_counter; //s
reg [NB_DATA_COUNT - 1:0] data_counter;
reg [NB_DATA       - 1:0] shiftreg; //data

always @(posedge i_clock)begin
    if(i_reset)
        state <= STATE_WAIT;
    else 
        state <= next_state;
end

always @(*) begin: next_state_logic
    case (state)
        STATE_WAIT: begin
            case (i_rx)
                1'b0: begin
                    next_state   = STATE_START;
                    tick_counter = {NB_COUNT{1'b0}};
                end
                default: 
                    next_state = STATE_WAIT;
            endcase
            rx_done_tick = 0;
        end
        STATE_START: begin
            case (tick_counter)
                MID_STOP: begin
                    next_state   = STATE_PHASE;
                    tick_counter = {NB_COUNT{1'b0}}; //s
                    data_counter = {NB_DATA_COUNT{1'b0}}; //n
                end
                default: begin
                    next_state   = STATE_START;
                    tick_counter = tick_counter + 1;
                end
            endcase
        end
        STATE_PHASE: begin
            case (tick_counter)
                END_STOP: begin
                    next_state   = STATE_RECEIVE;
                    tick_counter = {NB_COUNT{1'b0}};
                    shiftreg = {i_rx, shiftreg[NB_DATA-1:1]};
                end
                default: begin
                    next_state   = STATE_PHASE;
                    tick_counter = tick_counter + 1;
                end
            endcase
        end
        STATE_RECEIVE: begin
            case (data_counter)
                NB_DATA:
                    next_state = STATE_STOP;
                default: begin
                    next_state   = STATE_PHASE;
                    data_counter = data_counter + 1;
                end
            endcase
        end
        STATE_STOP: begin 
            case (tick_counter) //preguntar !!!!!!!!!!
                N_STOP: begin
                    next_state = STATE_WAIT;
                    rx_done_tick = 1;
                end
                default: begin
                    next_state = STATE_STOP;
                    tick_counter = tick_counter + 1;
                end
            endcase
        end
        default:
            next_state = STATE_WAIT; //preguntar
    endcase
end

assign o_data = (rx_done_tick) ? shiftreg:{NB_DATA{1'b0}};

endmodule