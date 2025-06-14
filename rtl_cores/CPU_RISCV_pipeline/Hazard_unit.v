module Hazard_unit (
    // INPUTS
    input  [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input        PCSrcE, ResultSrcE0, RegWriteM, RegWriteW,

    // OUTPUTS
    output reg [1:0] ForwardAE, ForwardBE,
    output           StallF, StallD, FlushD, FlushE,
	 output        Forwardr1D, Forwardr2D
);

    // Forwarding 
    always @(*) begin
        // ForwardAE
        if ((Rs1E == RdM) && RegWriteM && (Rs1E != 5'b0))
            ForwardAE = 2'b10; // from MEM
        else if ((Rs1E == RdW) && RegWriteW && (Rs1E != 5'b0))
            ForwardAE = 2'b01; // from WB
        else
            ForwardAE = 2'b00; // no forwarding

        // ForwardBE
        if ((Rs2E == RdM) && RegWriteM && (Rs2E != 5'b0))
            ForwardBE = 2'b10; // from MEM
        else if ((Rs2E == RdW) && RegWriteW && (Rs2E != 5'b0))
            ForwardBE = 2'b01; // from WB
        else
            ForwardBE = 2'b00; // no forwarding
    end

    // Stall and flush 
    wire load_hazard = ResultSrcE0 && ((Rs1D == RdE) || (Rs2D == RdE));

    assign FlushE  = load_hazard || PCSrcE;
    assign StallF  = load_hazard; 
    assign StallD  = load_hazard;
    assign FlushD  = PCSrcE;         
	 
	 
	 //Decode
	 
    assign   Forwardr1D	= ((Rs1D == RdW) && RegWriteW &&(Rs1D != 5'b0))? 1:0; 
	 assign   Forwardr2D	= ((Rs2D == RdW) && RegWriteW &&(Rs2D != 5'b0) )? 1:0; 
endmodule
