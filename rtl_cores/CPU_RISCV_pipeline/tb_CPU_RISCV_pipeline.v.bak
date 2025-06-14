`timescale 1ns/1ps

module tb_CPU_RISCV_pipeline;

    reg clk = 0;
    reg reset = 0;

    wire done;
    wire [8:0] cycle_number;
    wire [31:0] register3, pc;

    // Instanciation du module CPU_RISCV_pipeline
    CPU_RISCV_pipeline uut (
        .reset(reset),
        .clk(clk),
        .cycle_number(cycle_number),
        .done(done),
        .register3(register3),
        .pc(pc)
    );

    // Génération de l'horloge avec une période de 15 unités de temps
    always #7.5 clk = ~clk;

    initial begin
        // Initialisation
        $display("Temps\tCycle\tPC\t\tReg3");
        $monitor("%4dns\t%3d\t%h\t%h", $time, cycle_number, pc, register3);

        // Phase de reset
        reset = 0; #5;
        reset = 1; #5;
        reset = 0;

        // Simulation pendant un temps suffisant
        #500;

        $finish;
    end

    // Affichage spécifique à chaque front montant
    always @(posedge clk) begin
        if (register3 == 32'd55) begin
            $display(">>> À %dns: register3 == 55", $time);
        end
    end

endmodule
