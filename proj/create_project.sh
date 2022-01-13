#!/bin/sh

PROJ_NAME="arty_uart_rx_tx"
vivado -mode batch -source $PROJ_NAME.tcl
cd $PROJ_NAME && vivado -mode gui $PROJ_NAME.xpr

rm -f *.jou *.log
rm -r .Xil/