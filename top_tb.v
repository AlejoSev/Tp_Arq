`timescale 1ns / 1ps

module top_tb;
    parameter NB_INPUTS = 8;
    parameter NB_OUTPUTS = 8;
    parameter NB_OP = 6;
    parameter N_tests = 10;
   

    reg                     clock;
    reg                     reset;
    reg  [2:0]              buttons;
    reg  [NB_INPUTS-1:0]    switches;
    wire [NB_OUTPUTS-1:0]   leds;

    reg [NB_INPUTS-1:0] random_a;
    reg [NB_INPUTS-1:0] random_b;
    reg [NB_OP-1:0]     operations [7:0];

    integer op_counter;
    integer tests_counter;

    initial begin
        clock = 0;
        reset = 0;
        switches = 8'd1;
        buttons = 3'd0;

        op_counter = 0;
        tests_counter = 0;
        
        operations[0] = 32;
        operations[1] = 34;
        operations[2] = 36;
        operations[3] = 37;
        operations[4] = 38;
        operations[5] = 3;
        operations[6] = 2;
        operations[7] = 39;
        
         $display("--------------------------------------");
          $display("Starting Tests");

      for(op_counter = 0; op_counter <= (NB_OP+1); op_counter = op_counter+1)begin
           
            for(tests_counter = 0; tests_counter <= N_tests; tests_counter = tests_counter+1)begin
                #10
                random_a = $urandom;
                switches = random_a;
                buttons = 3'd1;

                #10
                random_b = $urandom;
                switches = random_b;
                buttons = 3'd2;

                #10
                switches = operations[op_counter];
                buttons = 3'd4;

                #10
                case(operations[op_counter])
                    32: if(random_a + random_b !== leds) begin
                        $display("%b + %b = %b", random_a, random_b, leds);
                        $display("Error en la suma");
                        end
                    34: if(random_a - random_b !== leds) begin
                        $display("%b - %b = %b", random_a, random_b, leds);
                        $display("Error en la resta");
                        end
                    36: if((random_a & random_b) !== leds) begin
                        $display("%b & %b = %b", random_a, random_b, leds);
                        $display("Error en la and");
                        end
                    37: if((random_a | random_b) !== leds) begin
                        $display("%b | %b = %b)", random_a, random_b, leds);
                        $display("Error en la or");
                        end
                    38: if((random_a ^ random_b) !== leds) begin
                        $display("%b ^ %b = %b", random_a, random_b, leds);
                        $display("Error en la xor");
                        end
                    3: if((random_a >>> random_b) !== leds) begin
                        $display("%b >>> %b = %b", random_a, random_b, leds);
                        $display("Error en la sra");
                        end
                    2: if((random_a >> random_b) !== leds) begin
                        $display("%b >> %b = %b", random_a, random_b, leds);
                        $display("Error en la srl");
                        end
                    39: if((~(random_a | random_b)) != leds) begin
                        $display("~(%b | %b) = %b", random_a, random_b, leds);
                        $display("Error en la nor");
                        end
                endcase
            end

            $display("Test %d terminado", op_counter);
        end

        // #10
        // buttons = 3'd1; //Carga data_a
        // #10
        // buttons = 3'd2; //Carga data_b
        // #10
        // switches = 6'b100000; //Add
        // buttons = 3'd4; //Carga operation
        
        // #10

        #10
        $finish;
    end

    always #5 clock = ~clock;

    top top_instance(   .i_clock(clock), 
                        .i_reset(reset),
                        .i_buttons(buttons),
                        .i_switches(switches),
                        .o_leds(leds));

endmodule