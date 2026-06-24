# ============================================================
#  E85 Lab 2 — shared Verilator simulation harness
# ============================================================
# This is the "parent" Makefile that the per-lab folders
# (e.g. lab2_XX/) delegate to with `$(MAKE) -C .. ...`.
#
# It hides the raw Verilator command line behind one generic
# `sim` target. A lab-local Makefile supplies:
#
#   SIM_NAME   base name for the executable + waveform (e.g. fulladder)
#   TB_TOP     top-level testbench module name
#   SRCS       space-separated .sv sources (design + testbench),
#              named relative to RUN_DIR
#   RUN_DIR    directory the simulation runs from (so $readmemb finds
#              the .tv file and waves/ lands next to the sources)
#
# Verilator (unlike Questa) has no interactive GUI simulator; it
# compiles the design into a native executable that, when run,
# self-checks and writes a VCD waveform for Vapor View.
# ============================================================

SHELL := /bin/bash

VERILATOR ?= verilator

# ---- knobs supplied by the lab-local Makefile ----
SIM_NAME  ?= sim
TB_TOP    ?= testbench
SRCS      ?=
RUN_DIR   ?= $(CURDIR)

WAVES_DIR ?= $(RUN_DIR)/waves

# --binary : verilate + compile + link into one native executable
# --timing : support #delays and clocked procedural blocks in the TB
# --trace  : compile in VCD tracing (TB calls $dumpfile/$dumpvars)
# -Wno-fatal / -Wno-TIMESCALEMOD : keep lint nits from aborting the build
# -Mdir obj_dir : put generated C++ in RUN_DIR/obj_dir (we cd there first)
VERILATOR_FLAGS ?= --binary --timing --trace \
	--top-module $(TB_TOP) \
	-Wno-fatal -Wno-TIMESCALEMOD \
	-Mdir obj_dir -o V$(SIM_NAME)

.PHONY: sim clean

sim:
	@echo "==> [Lab2] Verilating '$(SIM_NAME)' (top=$(TB_TOP)) from $(RUN_DIR)"
	@mkdir -p $(WAVES_DIR)
	cd $(RUN_DIR) && $(VERILATOR) $(VERILATOR_FLAGS) $(SRCS)
	@echo "==> [Lab2] Running simulation '$(SIM_NAME)'"
	@cd $(RUN_DIR) && set -o pipefail; \
		./obj_dir/V$(SIM_NAME) 2>&1 | tee $(SIM_NAME).log; \
		if grep -Eq "completed with +0 errors" $(SIM_NAME).log; then \
			echo "==> [Lab2] PASS: $(SIM_NAME)  (waveform: waves/$(SIM_NAME).vcd)"; \
		else \
			echo "==> [Lab2] FAIL: $(SIM_NAME) reported errors (see $(SIM_NAME).log)"; \
			exit 1; \
		fi

# clean is RUN_DIR-scoped: removes only generated artifacts, never sources
clean:
	@echo "==> [Lab2] Cleaning generated artifacts in $(RUN_DIR)"
	rm -rf $(RUN_DIR)/obj_dir
	rm -rf $(RUN_DIR)/waves
	rm -f  $(RUN_DIR)/*.log
