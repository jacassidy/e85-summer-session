# Lab-local Makefile for Lab 4 — delegates to the shared harness in ../Makefile.
# Copy this folder to lab4_<your initials> and do your work there.
#
#   make adventure-sim   build + run the self-checking testbench
#   make clean           remove obj_dir/, waves/ and *.log

LAB_DIR := $(CURDIR)

.PHONY: adventure-sim clean

adventure-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=adventure \
		TB_TOP=testbench \
		SRCS="adventure.sv adventure_tb.sv" \
		RUN_DIR=$(LAB_DIR)

clean:
	$(MAKE) -C .. clean RUN_DIR=$(LAB_DIR)
