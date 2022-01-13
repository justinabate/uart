
module uart_rx_tx_top (
  // 100 MHz free-running board clock
  input              i_clk,
  // pushbutton
  input              i_rst_n,
  // input serial data line
  input              i_rxd,
  // output serial data line
  output             o_txd,
  // output ground reference
  output             o_gnd,

  // ARTY 8x SMT LED vector
  output logic [7:0] o_led

);
 
  parameter         c_baud_rate     = 115200;                 // target UART baud rate
  parameter         c_clk_rate      = c_baud_rate*64;         // 7.3728 MHz
  parameter integer c_clks_per_bit  = c_clk_rate/c_baud_rate; // 64

  logic        w_uart_refclk;
  logic        w_mmcm_locked;

  logic        w_uart_tx_s_axis_tready;
  logic        w_uart_rx_m_axis_tvalid;  
  logic [7:0]  w_uart_rx_m_axis_tdata;
  logic        w_txd_busy, w_rxd_busy;


mmcm #() i_mmcm (
  // Clock in ports
  .i_clk(i_clk), // input         
  // Status and control signals
  .resetn(i_rst_n), // input         
  // Clock out ports
  .o_clk(w_uart_refclk), // output
  .o_locked(w_mmcm_locked) // output        
 );

  uart_rx_wrap #(
    .CLKS_PER_BIT(c_clks_per_bit),
    .USE_FIFO(1)
  ) i_uart_rx_wrap (
    // clk, rst
    .i_clk(w_uart_refclk),
    .i_rst_n(i_rst_n),
    // input serial data line
    .i_rxd(i_rxd),
    // output AXIS master port
    .i_m_axis_tready(w_uart_tx_s_axis_tready),
    .o_m_axis_tvalid(w_uart_rx_m_axis_tvalid),
    .o_m_axis_tdata(w_uart_rx_m_axis_tdata),
    // output status signals
    .o_rxd_busy(w_rxd_busy)
  );

  // loopback
  uart_tx #(
    .CLKS_PER_BIT(c_clks_per_bit)
  ) i_uart_tx (
    // clk, rst
    .i_clk(w_uart_refclk),
    // input AXIS slave port
    .o_s_axis_tready(w_uart_tx_s_axis_tready),
    .i_s_axis_tvalid(w_uart_rx_m_axis_tvalid),
    .i_s_axis_tdata(w_uart_rx_m_axis_tdata),
    // output serial data line
    .o_txd(o_txd),
    // output status signals
    .o_txd_busy(w_txd_busy),
    .o_txd_done()
  );


  assign o_led[0] = w_rxd_busy;
  assign o_led[1] = w_txd_busy;
  assign o_led[3] = w_mmcm_locked;
  assign o_gnd = 1'b0;
   
   
endmodule