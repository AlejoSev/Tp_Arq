`timescale 1ns / 1ps
//mock para generar datos sincronizados con baudrate genertor

module data_generator 
#( parameter NB_TOTAL_DATA = 11, //stop-bit + 8bit + 2 stop-bit
   parameter NB_COUNT = 4) 
(
    input wire i_s_tick,
    input wire i_reset,
    output wire o_data
);

reg [NB_COUNT - 1 : 0] counter;

always @(posedge i_s_tick) begin
    if(i_reset) begin
        counter <= {1'b0{NB_TOTAL_DATA}};
    end
    else begin
        if(counter < NB_TOTAL_DATA)
            counter <= counter + 1;
        else
            counter <= {1'b0{NB_TOTAL_DATA}};
    end
end
//trama algo como: 0 1000 0000 11
assign o_data = ((counter == 0) && ~i_reset)? 1'b0 : 
                (counter == 1 )? 1'b1:
                ((counter >= 2) && (counter < 9))? 1'b0: 1'b1;
endmodule