TOPLEVEL_LANG ?= verilog 
SIM ?= icarus 

VERILOG_SOURCES := $(abspath ../rtl/uart_tx.v)
TOPLEVEL = uart_tx 
MODULE = tx_test

IVERILOG_ARGS += -g2012 

include $(shell cocotb-config --makefiles)/Makefile.sim