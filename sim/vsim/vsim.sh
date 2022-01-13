#!/usr/bin/sh

# setup
mkdir -p libraries
mkdir -p libraries/work

# run
vlog -sv ../../hdl/beh/uart_tb.v
vsim work.uart_tb -t 1fs -do ./includes/run.do

# teardown
rm transcript vsim.wlf
rm -r libraries
