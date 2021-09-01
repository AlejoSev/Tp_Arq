module tb_alu;
    parameter NB_INPUTS = 8;
    parameter NB_OUTPUTS = 8;
    parameter NB_OP = 6;

    reg [NB_INPUTS-1:0]     dato_a;
    reg [NB_INPUTS-1:0]     dato_b;
    reg [NB_OP-1:0]         operation;
    wire [NB_OUTPUTS-1:0]   result;

    initial begin
        dato_a = 1;
        dato_b = 1;
        operation = NB_OP'b100000;

        #10
        operation = NB_OP'b100010;

        #10
        operation = NB_OP'b100100;

        #10
        operation = NB_OP'b100101;

        #10
        operation = NB_OP'b100110;

        #10
        operation = NB_OP'b100111;

        #10
        $finish;
    end

    alu alu_instance(.i_dato_a(dato_a), .i_dato_b(dato_b), .i_operation(operation), o_result(result));

endmodule