# E85 Lab 2 — FPGA Tools and Combinational Logic Design (Verilator edition)

This is a **simulation-only** substitute for the original Lab 2. Instead of
Quartus, Questa, the RTL Viewer, pin planning, and a physical DE0-CV board,
you build and self-check your designs with **Verilator** on the command line
and inspect waveforms with **Vapor View**. The assignment itself — the
structural full adder tutorial and the ALU Decoder design — is unchanged.

## Files

| File | Purpose |
|------|---------|
| `fulladder.sv`     | Structural full adder (tutorial, complete). |
| `testbench.sv`     | Self-checking testbench for the full adder. |
| `fulladder.tv`     | 8 test vectors (the full adder truth table). |
| `aludecoder.sv`    | **STUB** — your ALU Decoder goes here (Table 7.3). |
| `aludecoder_tb.sv` | Self-checking testbench scaffold for the decoder. |
| `aludecoder.tv`    | ALU Decoder test vectors. |
| `Makefile`         | Student-facing targets (delegates to `../Makefile`). |
| `waves/`           | Generated VCD waveforms — **not edited by hand**. |
| `obj_dir/`         | Generated Verilator build output — **not edited by hand**. |

## Commands

```bash
make lab2-fulladder-sim    # tutorial: should report "8 tests completed with 0 errors"
make lab2-aludecoder-sim   # your design: FAILS until you implement aludecoder.sv
make clean                 # remove waves/, obj_dir/, *.log (keeps sources + .tv)
```

A target exits **nonzero** if the simulation reports any errors.

## Viewing waveforms with Vapor View

```bash
find . -name "*.vcd" -o -name "*.fst"
vaporview waves/fulladder.vcd
vaporview waves/aludecoder.vcd
```

## Workflow

1. Run `make lab2-fulladder-sim` first to confirm your tool setup works
   (expect `8 tests completed with 0 errors` and `waves/fulladder.vcd`).
2. Implement the ALU Decoder in `aludecoder.sv` from Table 7.3:
   - Inputs: `ALUOp[1:0]`, `funct3[2:0]`, `op5`, `funct75`
   - Output: `ALUControl[2:0]`
   - Only the meaningful rows matter; other combinations are don't cares.
3. Run `make lab2-aludecoder-sim` until it reports 0 errors, then check the
   waveform in Vapor View.

> The stub `aludecoder.sv` drives `ALUControl = 000` for all inputs, so the
> decoder sim **fails on purpose** until you do the assignment. That failure
> is the expected starting point — it shows the harness is wired correctly.
