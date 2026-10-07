# Lab-local Makefile for Lab 3 — delegates to the shared harness in ../Makefile.
# Copy this folder to lab3_<your initials> and do your work there.
#
#   make thunderbird-sim   build + run the self-checking testbench
#   make clean             remove obj_dir/, waves/ and *.log

LAB_DIR := $(CURDIR)

.PHONY: thunderbird-sim clean

thunderbird-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=thunderbird \
		TB_TOP=testbench \
		SRCS="thunderbird.sv thunderbird_tb.sv" \
		RUN_DIR=$(LAB_DIR)

clean:
	$(MAKE) -C .. clean RUN_DIR=$(LAB_DIR)
