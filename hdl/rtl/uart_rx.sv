//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_rx #(
  parameter CLKS_PER_BIT = 16
)(
  input        i_clk,
  // input serial data line
  input        i_rxd,
  // output AXIS master port
  output       o_m_axis_tvalid,
  output [7:0] o_m_axis_tdata,
  // output status signals
  output       o_rxd_busy
);

  typedef enum logic [2:0] {IDLE, START, RXDATA, STOP, PAUSE} t_fsm;
  t_fsm         r_fsm_cs;
   
  // synchroniser
  reg [1:0]     r_rxd_sync;
  wire          w_rxd_sync;
  
  //! counter for clocks per bit
  parameter g_W = $clog2(CLKS_PER_BIT);
  reg [g_W-1:0] r_clk_count = 0;

  reg [2:0]     r_bit_idx   = 0; // log2(8) 

  // regs for AXIS output
  reg [7:0]     r_tdata     = 0;
  reg           r_tvalid    = 0;
  reg           r_sample_valid;
   
  // double-flop synchronise the rxd serial data
  always @(posedge i_clk) begin // : p_rxd_synchroniser
    r_rxd_sync = {r_rxd_sync[0], i_rxd};
  end
  assign w_rxd_sync = r_rxd_sync[1];
   

  always @(posedge i_clk) begin // : p_fsm
       
    case (r_fsm_cs)


      IDLE : begin
        r_tvalid    <= 1'b0;
        r_sample_valid <= 1'b0;
        r_clk_count <= 0;
        r_bit_idx   <= 0;
        
        // Start bit detected
        if (w_rxd_sync == 1'b0) begin          
          r_fsm_cs <= START;
        end else begin
          r_fsm_cs <= IDLE;
        end
      end
       
      
      START : begin
        if (r_clk_count == (CLKS_PER_BIT-1)/2) begin
          // ensure middle of start bit is still low
          if (w_rxd_sync == 1'b0) begin
            r_fsm_cs    <= RXDATA;
            r_clk_count <= 0;  // reset counter, found the middle
          end else begin
            r_fsm_cs <= IDLE;
          end
        end else begin
          r_fsm_cs    <= START;
          r_clk_count <= r_clk_count + 1;
        end
      end 
       
       
      RXDATA : begin
        
        // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
        if (r_clk_count == CLKS_PER_BIT-1) begin
          r_clk_count        <= 0;
          r_tdata[r_bit_idx] <= w_rxd_sync;
          r_sample_valid    <= 1'b1;
           
          if (r_bit_idx == 7) begin
            r_fsm_cs  <= STOP; // transition after 8 bits received
            r_bit_idx <= 0;
          end else begin
            r_fsm_cs  <= RXDATA;
            r_bit_idx <= r_bit_idx + 1;
          end
        end else begin
          r_fsm_cs        <= RXDATA;
          r_clk_count     <= r_clk_count + 1;
          r_sample_valid <= 1'b0;
        end

      end
    
    
      STOP : begin

        r_sample_valid <= 1'b0;

        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        // Stop bit = 1'b1 (not checked for correctness)
        if (r_clk_count == CLKS_PER_BIT-1) begin
          r_tvalid    <= 1'b1;
          r_clk_count <= 0;
          r_fsm_cs    <= PAUSE;
        end else begin
          r_clk_count <= r_clk_count + 1;
          r_fsm_cs    <= STOP;
        end

      end
    

      PAUSE : begin
        r_fsm_cs  <= IDLE;
        r_tvalid  <= 1'b0;
      end

      
      default : begin
        r_fsm_cs <= IDLE;
      end

    endcase
  end   
   
  assign o_m_axis_tdata   = r_tdata;
  assign o_m_axis_tvalid  = r_tvalid;

  assign o_rxd_busy = (r_fsm_cs == IDLE) ? 1'b0 : 1'b1;

   
endmodule // uart_rx