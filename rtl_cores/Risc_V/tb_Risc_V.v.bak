`timescale 1ns/1ps

module tb_Risc_V;

    reg clock = 0;
    reg reset = 0;
    reg run = 0;

    wire done;
    wire [3:0] state;
    wire [6:0] cycle_number;
    wire [31:0] register5, PC;

    // Instanciation du module Risc_V
    Risc_V uut (
        .reset(reset),
        .clock(clock),
        .run(run),
        .done(done),
        .state(state),
        .cycle_number(cycle_number),
        .register5(register5),
        .PC(PC)
    );

    // Horloge avec période de 15 unités de temps
    always #7.5 clock = ~clock;

    initial begin
        // Initialisation
        $display("Temps\tCycle\tPC\t\tReg5");
        $monitor("%4dns\t%2d\t%h\t%h", $time, cycle_number, PC, register5);

        // Phase de reset
        reset = 0; #5;
        reset = 1; #5;
        reset = 0;

        // Attendre un peu avant de lancer run
        #10;
        run = 1;

        // Simuler pendant un temps suffisant
        #300;

        $finish;
    end

    // Affichage spécifique à chaque front montant
    always @(posedge clock) begin
        if (register5 == 32'd55) begin
            $display(">>> At time %dns: register5 == 55", $time);
        end
    end

endmodule
