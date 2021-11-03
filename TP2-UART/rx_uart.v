`timescale 1ns / 1ps

module rx_uart
    #(parameter NB_STATE        = 3,
      parameter NB_COUNT        = 5,
      parameter NB_DATA_COUNT   = 4,
      parameter NB_DATA         = 8,
      parameter N_TICKS_TO_STOP = 30) //Cant. bits de stop * tick por bit (2 * 15)
    (input wire i_clock, // clock del baudrate generator
     input wire i_s_tick,
     input wire i_reset,
     input wire i_rx,
     output wire o_rx_done_tick,
     output wire [NB_DATA-1:0] o_data);

localparam [NB_STATE - 1:0] STATE_WAIT    = 3'd0 ;
localparam [NB_STATE - 1:0] STATE_START   = 3'd1 ;
localparam [NB_STATE - 1:0] STATE_PHASE   = 3'd2 ;
localparam [NB_STATE - 1:0] STATE_RECEIVE = 3'd3 ;
localparam [NB_STATE - 1:0] STATE_STOP    = 3'd4 ;
localparam [NB_COUNT - 1:0] MID_STOP      = 5'd7 ;
localparam [NB_COUNT - 1:0] END_STOP      = 5'd15;

reg [NB_STATE      - 1:0] state;
reg [NB_STATE      - 1:0] next_state;
reg [NB_COUNT      - 1:0] tick_counter; //s
reg [NB_DATA_COUNT - 1:0] data_counter;
reg [NB_DATA       - 1:0] shiftreg;     //data
reg                       rx_done_tick;
reg [1:0] soyUNreg; //borar

// always @(posedge i_clock)begin
//     if(i_reset) begin
//         state <= STATE_WAIT;
//     end
//     else
//         state <= next_state;
// end

always @(posedge i_s_tick)begin

    if(i_reset)begin
        tick_counter <= {NB_COUNT{1'b0}};
        data_counter <= {NB_DATA_COUNT{1'b0}};
        shiftreg     <= {NB_DATA{1'b0}};
        soyUNreg <= 1'b0;
        state <= STATE_WAIT;
        
    end
    else begin
        state <= next_state;
        soyUNreg <= soyUNreg ^ 1'b1;
        case (state)
        STATE_WAIT: begin
            tick_counter <= {NB_COUNT{1'b0}};
            data_counter <= {NB_DATA_COUNT{1'b0}};
            shiftreg     <= {NB_DATA{1'b0}};
            rx_done_tick <= 1'b0;
        end 
        STATE_START: begin
           
            if(tick_counter == MID_STOP)begin
                    tick_counter <= {NB_COUNT{1'b0}};
                    data_counter <= {NB_DATA_COUNT{1'b0}};
                end
            else
                tick_counter <= tick_counter + 1;
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

assign o_data = (rx_done_tick) ? shiftreg:{NB_DATA{1'b0}};
assign o_rx_done_tick = rx_done_tick;

endmodule