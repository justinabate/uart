`timescale 1ns/10ps




//! direct output or FIFO buffered output 
module uart_rx_wrap #(
  parameter int CLKS_PER_BIT = 16,
  parameter bit USE_FIFO = 1
)(
  // clk, rst
  input        i_clk,
  input        i_rst_n,
  // input serial data line
  input        i_rxd,
  // output AXIS master port
  input        i_m_axis_tready,
  output       o_m_axis_tvalid,
  output [7:0] o_m_axis_tdata,
  // output status signals
  output       o_rxd_busy

);


  logic [7:0]  w_uart_rx_tdata;
  logic        w_uart_rx_tvalid;


  generate

    if (USE_FIFO) begin : gen_fifo

      axis_fifo_wrap #(
        .G_FIFO_DEPTH(64),
        .G_WORD_WIDTH( $size(o_m_axis_tdata) )
      ) inst_axis_fifo_wrap (

        .i_clk(i_clk),    // input; Transfer clock 
        .i_arst_n(i_rst_n), // input; Asynchronous reset, active low

        // input AXIS slave port
        .o_s_axis_tready(), // output logic                         
        .i_s_axis_tvalid(w_uart_rx_tvalid), // input  logic                         
        .i_s_axis_tdata(w_uart_rx_tdata),  // input  logic [G_WORD_WIDTH-1:0] 
        .i_s_axis_thold(1'b0),  // input  logic [G_HOLD_WIDTH-1:0]; range 0 to G_WORD_WIDTH/8-1; 0=hold all; 1= hold [7:0], etc.

        // output AXIS master port
        .i_m_axis_tready(i_m_axis_tready), // input  logic                         
        .o_m_axis_tvalid(o_m_axis_tvalid), // output logic                         
        .o_m_axis_tdata(o_m_axis_tdata),  // output logic [G_WORD_WIDTH-1:0] 
        .o_m_axis_thold()   // output logic [G_HOLD_WIDTH-1:0]    
      );

    end else begin : gen_passthru

      //! if no FIFO in use, wire UART AXIS signals directly to output 
      assign o_m_axis_tvalid = w_uart_rx_tvalid;
      assign o_m_axis_tdata = w_uart_rx_tdata;

    end
  endgenerate


  // main UART logic
  uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) inst_uart_rx (
    .i_clk(i_clk),
    // input serial data line
    .i_rxd(i_rxd),
    // output AXIS master port
    .o_m_axis_tvalid(w_uart_rx_tvalid),
    .o_m_axis_tdata(w_uart_rx_tdata),
    // output status signals
    .o_rxd_busy(o_rxd_busy)
  );


endmodule