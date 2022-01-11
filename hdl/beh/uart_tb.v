//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
 
// - Testbench task serializes byte 0x55 to 'i_uart_rx_0'
// - AXIS master output port of 'i_uart_rx_0' 
//   ... is looped back to AXIS slave input port of 'i_uart_tx'
// - 'i_uart_tx' then serializes the received byte
// - 'i_uart_rx_1' checks the byte transmitted by 'i_uart_tx'

`timescale 1ns/10ps
 
`include "../rtl/uart_tx.v"
`include "../rtl/uart_rx.v"
 
module uart_tb ();
 
  // Testbench uses a 10 MHz clock
  // Want to interface to 115200 baud UART
  // 10,000,000 / 115,200 = 87 Clocks Per Bit

  parameter         c_baud_rate     = 115200;                 // target UART baud rate
  parameter         c_clk_rate      = 10e6;                   // target refclk (Hz)

  parameter         c_clk_per_ns    = 1e9/c_clk_rate;         // 1 / fclk
  parameter integer c_bit_per_ns    = 1e9/c_baud_rate;        // 1 / 115200 = 8681 ns per serial bit
  parameter integer c_clks_per_bit  = c_clk_rate/c_baud_rate; // 10e6 / 115200 = 87 cycles per serial bit
   
  reg         refclk = 0;

  reg [7:0]   test_word = 8'h55; 
  
  wire        w_txd;
  reg         r_rxd = 1;

  wire [7:0]  w_uart_rx_0_tdata, w_uart_rx_1_tdata;
  wire        w_uart_rx_0_tvalid, w_uart_rx_1_tvalid;
   
  reg [7:0]   r_uart_tx_tdata = 0;
  reg         r_uart_tx_tvalid = 0;
 

  // serializes a single byte for driving a UART RxD line 
  task t_drive_rxd;
    input [7:0] i_Data;
    integer     ii;
  begin
       
      // Send Start Bit
      r_rxd <= 1'b0; #(c_bit_per_ns);
      #1000;
       
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1) begin
        r_rxd <= i_Data[ii];
        #(c_bit_per_ns);
      end
       
      // Send Stop Bit
      r_rxd <= 1'b1; #(c_bit_per_ns);
  end
  endtask 
   

  // driven by task
  uart_rx #(
    .CLKS_PER_BIT(c_clks_per_bit)
  ) i_uart_rx_0 (
    .i_clk(refclk),

    .i_rxd(r_rxd),

    .o_m_axis_tvalid(w_uart_rx_0_tvalid),
    .o_m_axis_tdata(w_uart_rx_0_tdata)
  );

  // loopback
  uart_tx #(
    .CLKS_PER_BIT(c_clks_per_bit)
  ) i_uart_tx (

    .i_clk(refclk),

    .o_s_axis_tready(),
    .i_s_axis_tvalid(w_uart_rx_0_tvalid),
    .i_s_axis_tdata(w_uart_rx_0_tdata),

    .o_txd(w_txd),
    .o_txd_busy(),
    .o_txd_done()
  );

  // tx checker
  uart_rx #(
    .CLKS_PER_BIT(c_clks_per_bit)
  ) i_uart_rx_1 (
    .i_clk(refclk),

    .i_rxd(w_txd),

    .o_m_axis_tvalid(w_uart_rx_1_tvalid),
    .o_m_axis_tdata(w_uart_rx_1_tdata)
  );   
 
   
  always #(c_clk_per_ns/2) refclk <= !refclk;
 
   
  // Main Testing:
  initial begin
    
    repeat(100) @(posedge refclk);
    t_drive_rxd(test_word); // Send a command to the UART (exercise Rx)
           
    @(posedge w_uart_rx_1_tvalid) begin
      if (w_uart_rx_1_tdata == test_word) begin
        $display("Test Passed - Correct Byte Received");
        repeat(100) @(posedge refclk);
        $stop;
      end else begin
        $display("Test Failed - Incorrect Byte Received");
        repeat(100) @(posedge refclk);
        $stop;
      end
    end
       
    end
   
endmodule