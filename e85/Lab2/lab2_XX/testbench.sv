// Self-checking testbench for the full adder (device under test, DUT).
// It reads test vectors from fulladder.tv, applies the inputs, and checks
// the DUT outputs against the expected outputs.
//
// Notes vs. the original Questa lab:
//   * Ends with $finish (not $stop) for a clean command-line exit.
//   * Adds $dumpfile/$dumpvars so a VCD waveform is written for Vapor View.
//   * End-of-vectors detection: the original relied on Questa loading X into
//     unwritten memory and testing `=== 5'bx`. Verilator is a 2-state
//     simulator (X collapses to 0), so that never fires. Instead each vector
//     word carries an extra high "guard" bit: $readmemb zero-fills it for the
//     real vectors, and we prefill unloaded entries with 1s, so guard==1
//     marks "past the last vector". This is fully 2-state safe.
// Everything else mirrors the original tutorial testbench.
module testbench();

   logic clk, reset;
   logic a, b, cin, s, cout, sexpected, coutexpected;

   logic [31:0] vectornum, errors;     // count of vectors applied / errors found
   // bits [4:0] = {a,b,cin,coutexpected,sexpected}; bit [5] = guard (1 = none)
   logic [5:0]  testvectors[10000:0];

   // Instantiate device under test. Inputs: a,b,cin. Outputs: s,cout.
   fulladder dut(a, b, cin, s, cout);

   // Generate a clock with period of 10 time units.
   always begin
      clk = 1; #5;
      clk = 0; #5;
   end

   // Start of test.
   initial begin
      // Dump a VCD waveform for Vapor View (waves/ created by the Makefile).
      $dumpfile("waves/fulladder.vcd");
      $dumpvars(0, testbench);

      // Prefill all entries with 1s so the guard bit ([5]) is set; $readmemb
      // then zero-fills the guard bit on every line it loads.
      for (int i = 0; i <= 10000; i++) testvectors[i] = '1;
      $readmemb("fulladder.tv", testvectors);  // load binary vectors
      vectornum = 0;
      errors    = 0;
      reset = 1; #22; reset = 0;               // pulse reset for 2.2 cycles
   end

   // Apply test vectors on the rising edge of clk.
   always @(posedge clk) begin
      #1;
      {a, b, cin, coutexpected, sexpected} = testvectors[vectornum][4:0];
   end

   // Check results on the falling edge of clk.
   always @(negedge clk)
      if (~reset) begin                        // skip checking during reset
         if (s !== sexpected || cout !== coutexpected) begin
            $display("Error: inputs = %b", {a, b, cin});
            $display("  outputs = %b %b (%b %b expected)", s, cout,
                     sexpected, coutexpected);
            errors = errors + 1;
         end
         vectornum = vectornum + 1;
         if (testvectors[vectornum][5] === 1'b1) begin  // guard bit -> no more vectors
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish;
         end
      end
endmodule
