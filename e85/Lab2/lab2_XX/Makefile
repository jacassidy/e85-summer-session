# ============================================================
#  E85 Lab 2 — lab-local Makefile  (student-facing targets)
# ============================================================
# Thin wrapper: every target delegates to the shared harness in
# the parent directory (../Makefile) so you never touch a raw
# Verilator command line.
#
#   make lab2-fulladder-sim   # tutorial full adder (should PASS)
#   make lab2-aludecoder-sim  # your ALU Decoder    (FAILS until you build it)
#   make clean                # remove generated obj_dir/, waves/, *.log
#
# After a sim, find and open the waveform with Vapor View:
#   find . -name "*.vcd" -o -name "*.fst"
#   vaporview waves/fulladder.vcd
# ============================================================

LAB_DIR := $(CURDIR)

.PHONY: lab2-fulladder-sim lab2-aludecoder-sim clean

# --- Tutorial: structural full adder, vector-driven self-checking TB ---
lab2-fulladder-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=fulladder \
		TB_TOP=testbench \
		SRCS="fulladder.sv testbench.sv" \
		RUN_DIR=$(LAB_DIR)

# --- Assignment: ALU Decoder (Table 7.3). aludecoder.sv is a stub. ---
lab2-aludecoder-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=aludecoder \
		TB_TOP=aludecoder_tb \
		SRCS="aludecoder.sv aludecoder_tb.sv" \
		RUN_DIR=$(LAB_DIR)

clean:
	$(MAKE) -C .. clean RUN_DIR=$(LAB_DIR)
