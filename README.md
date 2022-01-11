# Brief 
Verilog UART via nandland<br/>
https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html<br/>

# Diagram

![uart_tb](https://i.imgur.com/HB4Ewnd.png)
<br/>

# Change log
- f712b6c: Added vsim setup<br/>
- 8dce517: Changed uart_rx output port to AXI stream master <br/>
- 8dce517: Changed uart_tx input port to AXI stream slave <br/>
- 8dce517: Changed testbench architecture for RX->TX loopback<br/>
- 8dce517: Removed relational operator logic ("<") from TX and RX FSMs <br/>
