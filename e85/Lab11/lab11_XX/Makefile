# Lab-local Makefile for Lab 11 — delegates to the shared harness in ../Makefile.
# Copy this folder to lab11_<your initials> and do your work there.
#
#   make processor-sim   build + run the self-checking testbench
#   make clean           remove obj_dir/, waves/ and *.log
#
# The processor testbench reports success as "Simulation succeeded" rather
# than a test count, which the shared harness in ../Makefile also accepts.

LAB_DIR := $(CURDIR)

.PHONY: processor-sim clean

processor-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=processor \
		TB_TOP=testbench \
		SRCS="processor.sv processor_tb.sv" \
		RUN_DIR=$(LAB_DIR)

clean:
	$(MAKE) -C .. clean RUN_DIR=$(LAB_DIR)
