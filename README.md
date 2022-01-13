# Brief 
Verilog UART via nandland<br/>
https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html<br/>

# Diagram

![uart_tb](https://i.imgur.com/HB4Ewnd.png)
<br/>

# Usage
## Build for ARTY Rev C (xc7a35t)
cd to proj/ <br/>
```
$ ./create_project.sh
```
## Simulation
cd to sim/vsim/ <br/>
```
$ ./vsim.sh
```

# Change log
- 75a457d: Added Vivado build for Arty Rev C
- 2902ec6: Added optional buffer FIFO to RX datapath (uart_rx_wrap)
- f712b6c: Added vsim setup<br/>
- 8dce517: Changed uart_rx output port to AXI stream master <br/>
- 8dce517: Changed uart_tx input port to AXI stream slave <br/>
- 8dce517: Changed testbench architecture for RX->TX loopback<br/>
- 8dce517: Removed relational operator logic ("<") from TX and RX FSMs <br/>
