// ALU Decoder  (E85 Lab 2, Part 3)
// =================================================================
// TODO(student): implement the ALU Decoder from Table 7.3.
//
//   Inputs:  ALUOp[1:0], funct3[2:0], op5, funct75
//   Output:  ALUControl[2:0]
//
// Steps (from the lab):
//   1. Write Boolean equations for the three ALUControl bits.
//   2. Sketch the schematic.
//   3. Implement it here in STRUCTURAL Verilog (gate primitives
//      like the full adder, or assign statements per your equations).
//
// You only need to handle the meaningful rows of the truth table
// (see aludecoder.tv); other input combinations are don't cares.
//
// As shipped this is a STUB that drives ALUControl = 000 for every
// input, so `make lab2-aludecoder-sim` will report errors until you
// replace the body below with your real decoder.
// =================================================================
module aludecoder(input  logic [1:0] ALUOp,
                  input  logic [2:0] funct3,
                  input  logic       op5,
                  input  logic       funct75,
                  output logic [2:0] ALUControl);

   // ---- STUB: replace with your implementation ----
   assign ALUControl = 3'b000;

endmodule
