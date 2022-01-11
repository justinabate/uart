Verilog UART via nandland<br/>
https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html<br/><br/>

Change log:<br/>
- Changed uart_rx output port to AXI stream master <br/>
- Changed uart_tx input port to AXI stream slave <br/>
- Changed testbench architecture for RX->TX loopback<br/>
- Removed relational operator logic ("<") from TX and RX FSMs <br/>
