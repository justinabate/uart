#!/bin/sh

PROJ_NAME="uart_tx_rx"
vivado -mode batch -source create_vivado_project.tcl
cd $PROJ_NAME && vivado -mode gui $PROJ_NAME.xpr

rm -f *.jou *.log
rm -rf .Xil/