module uart_libro
    #(
        parameter DBIT = 8,
        parameter SB_TICK = 16
    )
    (
        input wire i_clock, i_reset,
        input wire i_rx, i_s_tick,
        output reg o_rx_done_tick,
        output wire [7:0] o_data
    );

localparam [1:0] = 
    idle = 2'b00,
    start = 2'b01,
    data = 2'b01,
    stop = 2'b11;

reg [1:0] state, next_state;
reg [3:0] tick_counter;
reg [2:0] data_counter;
reg [7:0] shiftreg; //shiftreg

always @(posedge i_clock) begin

    if (i_reset) begin
        begin
            state <= idle;
            tick_counter <= 0;
            data_counter <= 0;
            shiftreg <= 0;
            o_rx_done_tick <= 1'b0;
        end
    end
    else begin
        state <= next_state;
        tick_counter <= tick_counter;
        data_counter <= data_counter;
        shiftreg <= shiftreg;
    end
end
    
always @(*) begin

    // next_state = state;
    o_rx_done_tick = 1'b0;
    // tick_counter = tick_counter;
    // data_counter = data_counter;
    // shiftreg = shiftreg;

    case (state)
        idle: begin
            if(~i_rx)begin
                next_state = start;
                tick_counter = 0;
            end
        end
        start: begin
            if(i_s_tick) begin
                if(tick_counter == 7) begin
                    next_state = data;
                    tick_counter = 0;
                    data_counter = 0;
                end
                else
                    tick_counter = tick_counter + 1;
            end
        end
        data: begin
            if(i_s_tick)begin
                if(tick_counter == 15) begin
                    tick_counter = 0;
                    shiftreg = {i_rx, shiftreg[7:1]};
                    if(data_counter == (DBIT-1))
                        next_state = stop;
                    else
                        data_counter = data_counter + 1;
                end
                else
                    tick_counter = tick_counter + 1;
            end
        end
        stop: begin
            if(i_s_tick) begin
                if(tick_counter == (SB_TICK - 1)) begin
                    next_state = idle;
                    o_rx_done_tick ) 1'b1;
                end
                else
                    tick_counter = tick_counter +;
            end
        end
    endcase   
end

assign o_data = shiftreg;
endmodule