#!/bin/sh


rm -f *.jou *.log
rm -rf .Xil/

PROJ_NAME="uart_tx_rx"
vivado -mode batch -source vivado_batch_flow.tcl
vivado -mode gui $PROJ_NAME/$PROJ_NAME.xpr -source vivado_open.tcl
