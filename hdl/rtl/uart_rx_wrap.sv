`timescale 1ns/10ps

//! direct output or FIFO buffered output 
module uart_rx_wrap #(
  parameter CLKS_PER_BIT,
  parameter USE_FIFO = 1
)(
  // clk, rst
  input        i_clk,
  input        i_rst_n,
  // input serial data line
  input        i_rxd,
  // output AXIS master port
  input        i_m_axis_tready,
  output       o_m_axis_tvalid,
  output [7:0] o_m_axis_tdata
);


  logic [7:0]  w_uart_rx_tdata;
  logic        w_uart_rx_tvalid;


  // main UART logic
  uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) i_uart_rx (
    .i_clk(i_clk),
    .i_rxd(i_rxd),
    .o_m_axis_tvalid(w_uart_rx_tvalid),
    .o_m_axis_tdata(w_uart_rx_tdata)
  );


  generate

    if (USE_FIFO) begin

      //! FIFO read enable, empty
      logic        w_fifo_rena, w_fifo_empt; 
      //! FIFO read data 
      logic [7:0]  w_fifo_rdat; 
      //! FIFO read data valid 
      logic        r_fifo_rvld; 


      fifo_sync_sram_based #(
        .g_D( 32 ),
        .g_W( 8 )
      ) i_fifo (
        .i_clk  ( i_clk ),
        .i_rst_n( i_rst_n ),

        .i_wena( w_uart_rx_tvalid ),
        .i_wdat( w_uart_rx_tdata ),
        .o_werr(  ),

        .i_rena( w_fifo_rena ),
        .o_rdat( w_fifo_rdat ),
        .o_rerr(  ),

        .o_full(  ),
        .o_empt( w_fifo_empt ),
        .o_flvl(  ) 
      );      


      //! read data is valid 1 cycle after read enable signal
      always_ff @(posedge i_clk) begin
        r_fifo_rvld <= w_fifo_rena ? 1'b1 : 1'b0;
      end


      assign w_fifo_rena = i_m_axis_tready && ~w_fifo_empt;
      assign o_m_axis_tvalid = r_fifo_rvld;
      assign o_m_axis_tdata = w_fifo_rdat;

    end else begin

      //! if no FIFO in use, wire UART AXIS signals directly to output 
      assign o_m_axis_tvalid = w_uart_rx_tvalid;
      assign o_m_axis_tdata = w_uart_rx_tdata;

    end
  endgenerate


endmodule