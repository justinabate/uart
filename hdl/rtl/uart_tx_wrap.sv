`timescale 1ns/10ps




//! direct output or FIFO buffered output 
module uart_tx_wrap #(
  parameter int CLKS_PER_BIT = 16,
  parameter bit USE_FIFO = 1,
  parameter int G_AXIS_TDATA_SIZE = 32,
  parameter int G_AXIS_THOLD_SIZE = (G_AXIS_TDATA_SIZE/8 > 2) ? $clog2(G_AXIS_TDATA_SIZE/8) : 1
)(
  // clk, rst
  input                         i_clk,
  input                         i_arst_n,
  // input AXIS slave port
  output                        o_s_axis_tready,
  input                         i_s_axis_tvalid,
  input [G_AXIS_TDATA_SIZE-1:0] i_s_axis_tdata, 
  input [G_AXIS_THOLD_SIZE-1:0] i_s_axis_thold, //! range 0-3; 0=hold all; 1= hold [7:0], etc.
  // output serial data line
  output reg                    o_txd,
  // output status signals
  output                        o_txd_busy,
  output                        o_txd_done
);

  localparam int G_UART_IWS = 8;

  //! wires for input to UART driver
  logic [G_UART_IWS-1:0]  w_uart_tx_s_axis_tdata;
  logic                   w_uart_tx_s_axis_tready;
  logic                   w_uart_tx_s_axis_tvalid;

  //! UART driver busy
  logic                   w_txd_busy; 


  generate

    if (USE_FIFO) begin : gen_fifo

      //! wires from FIFO's S AXIS input port
      logic                         w_axis_fifo_s_axis_tready;

      //! wires from FIFO's M AXIS output port 
      logic [G_AXIS_TDATA_SIZE-1:0] w_axis_fifo_m_axis_tdata; 
      logic [G_AXIS_THOLD_SIZE-1:0] w_axis_fifo_m_axis_thold;
      logic                         w_axis_fifo_m_axis_tvalid;

      //! wires from brige's S AXIS input port
      logic                         w_axis_bridge_s_axis_tready;

      //! wires from brige's M AXIS output port
      logic [G_UART_IWS-1:0]        w_axis_bridge_m_axis_tdata;
      logic                         w_axis_bridge_m_axis_tvalid; 


      axis_fifo_wrap #(
        .G_FIFO_DEPTH(64),
        .G_WORD_WIDTH(G_AXIS_TDATA_SIZE)
      ) inst_axis_fifo_wrap (

        .i_clk(i_clk),    // input; Transfer clock 
        .i_arst_n(i_arst_n), // input; Asynchronous reset, active low

        // input AXIS slave port - from top level input
        .o_s_axis_tready(w_axis_fifo_s_axis_tready), // output logic                         
        .i_s_axis_tvalid(i_s_axis_tvalid), // input  logic                         
        .i_s_axis_tdata(i_s_axis_tdata),  // input  logic [G_WORD_WIDTH-1:0] 
        .i_s_axis_thold(i_s_axis_thold),  // input  logic [G_HOLD_WIDTH-1:0]

        // output AXIS master port - to bridge
        .i_m_axis_tready(w_axis_bridge_s_axis_tready), // input  logic                         
        .o_m_axis_tvalid(w_axis_fifo_m_axis_tvalid), // output logic                         
        .o_m_axis_tdata(w_axis_fifo_m_axis_tdata),  // output logic [G_WORD_WIDTH-1:0] 
        .o_m_axis_thold(w_axis_fifo_m_axis_thold)   // output logic [G_HOLD_WIDTH-1:0]    
      );


      axis_bridge #(
        .G_AXIS_TDATA_IWS(G_AXIS_TDATA_SIZE), //! bits
        .G_AXIS_TDATA_OWS(G_UART_IWS),
        //! LO_TO_HI - send starting at $low(i_s_axis_tdata) || HI_TO_LO - send starting at $high(i_s_axis_tdata)
        .G_TRANSFER_ORDER("LO_TO_HI") 
      ) inst_axis_bridge_32_to_8 (
        // clk, rst
        .i_clk(i_clk), // input  logic

        // input S AXIS port
        .o_s_axis_tready(w_axis_bridge_s_axis_tready), // output logic                              
        .i_s_axis_tvalid(w_axis_fifo_m_axis_tvalid), // input  logic                              
        .i_s_axis_tdata(w_axis_fifo_m_axis_tdata),  // input  logic [G_AXIS_TDATA_IWS-1:0]       
        //! thold range e.g. 0-3 for IWS=32, where 0=hold all; 1=hold [7:0], 2=hold [15:0], 3=hold [24:0]
        .i_s_axis_thold(w_axis_fifo_m_axis_thold),  // input  logic [G_AXIS_THOLD_IN_SIZE-1:0] 

        //! output M AXIS port
        .i_m_axis_tready(w_uart_tx_s_axis_tready), // input  logic                              
        .o_m_axis_tvalid(w_axis_bridge_m_axis_tvalid), // output logic                              
        .o_m_axis_tdata(w_axis_bridge_m_axis_tdata),  // output logic [G_AXIS_TDATA_OWS-1:0]       
        .o_m_axis_thold()   // output logic [G_AXIS_THOLD_OUT_SIZE-1:0]  
      );

      //! wrapper ready if FIFO isn't full
      assign o_s_axis_tready         = w_axis_fifo_s_axis_tready;
      //! output data/valid are sent from the bridge
      assign w_uart_tx_s_axis_tvalid = w_axis_bridge_m_axis_tvalid;
      assign w_uart_tx_s_axis_tdata  = w_axis_bridge_m_axis_tdata;

    end else begin : gen_passthru

      //! wrapper ready if UART is ready
      assign o_s_axis_tready         = w_uart_tx_s_axis_tready;
      assign w_uart_tx_s_axis_tvalid = i_s_axis_tvalid;
      assign w_uart_tx_s_axis_tdata  = i_s_axis_tdata;

    end
  endgenerate


  // Debug TX
  uart_tx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) inst_uart_tx (
    // clk, rst
    .i_clk(i_clk),
    // input AXIS slave port
    .o_s_axis_tready(w_uart_tx_s_axis_tready),
    .i_s_axis_tvalid(w_uart_tx_s_axis_tvalid),
    .i_s_axis_tdata(w_uart_tx_s_axis_tdata), // 8 bits wide
    // output serial data line
    .o_txd(o_txd),
    // output status signals
    .o_txd_busy(o_txd_busy),
    .o_txd_done(o_txd_done)
  );


endmodule
