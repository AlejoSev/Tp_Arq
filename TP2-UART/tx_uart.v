`timescale 1ns / 1ps

module tx_uart 
#(parameter DBIT = 8,
  parameter NB_STATE = 2,
  parameter SB_TICK = 16)
(
    input wire i_clock,
    input wire i_reset,
    input wire i_tx_start,
    input wire i_s_tick,
    input wire [DBIT-1:0] i_data,
    output reg o_tx_done_tick,
    output wire o_tx
);

localparam [NB_STATE : 0 ] IDLE  = 2'b00;
localparam [NB_STATE : 0 ] START = 2'b01;
localparam [NB_STATE : 0 ] DATA  = 2'b10;
localparam [NB_STATE : 0 ] STOP  = 2'b11;

reg [1:0] state_reg, state_next;
reg [3:0] s_reg, s_next;
reg [2:0] n_reg, n_next;
reg [DBIT-1:0] b_reg, b_next;
reg tx_reg, tx_next;

always @(posedge i_clock) begin //le saque el posedge reset
    if(i_reset)begin
        state_reg <= IDLE;
        s_reg <= 0;
        n_reg <= 0;
        b_reg <= 0;
        tx_reg <= 1'b1;
    end
    else begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
        tx_reg <= tx_next;
    end
end

always @(*) begin
    state_next = state_reg;
    o_tx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    tx_next = tx_reg;

    case(state_reg)
        IDLE: begin
            tx_next = 1'b1;
            if(i_tx_start) begin
                state_next = START;
                s_next = 0;
                b_next = i_data;
            end
        end
        START: begin
            tx_next = 1'b0;
            if(i_s_tick) begin
                if(s_reg == 15) begin
                    state_next = DATA;
                    s_next = 0;
                    n_next = 0;
                end
                else
                    s_next = s_reg + 1;
            end 
        end
        DATA: begin
            tx_next = b_reg[0];
            if(i_s_tick)begin
                if(s_reg == 15)begin
                    s_next = 0;
                    b_next = b_reg >> 1;
                    if(n_reg == (DBIT - 1))
                        state_next = STOP;
                    else
                        n_next = n_reg + 1;
                end
                else
                    s_next = s_reg + 1;
            end
        end
        STOP: begin
            tx_next = 1'b1;
            if(i_s_tick) begin
                if(s_reg == (SB_TICK -1)) begin
                    state_next = IDLE;
                    o_tx_done_tick = 1'b1;
                end
                else
                    s_next = s_reg + 1;
            end
        end
    endcase
end

assign o_tx = tx_reg;

endmodule