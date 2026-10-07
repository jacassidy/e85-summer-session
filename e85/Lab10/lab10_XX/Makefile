# Lab-local Makefile for Lab 10 — delegates to the shared harness in ../Makefile.
# Copy this folder to lab10_<your initials> and do your work there.
#
#   make controller-sim   build + run the self-checking testbench
#   make clean            remove obj_dir/, waves/ and *.log

LAB_DIR := $(CURDIR)

.PHONY: controller-sim clean

controller-sim:
	$(MAKE) -C .. sim \
		SIM_NAME=controller \
		TB_TOP=testbench \
		SRCS="controller.sv controller_tb.sv" \
		RUN_DIR=$(LAB_DIR)

clean:
	$(MAKE) -C .. clean RUN_DIR=$(LAB_DIR)
