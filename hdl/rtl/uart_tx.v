//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_tx #(
  parameter CLKS_PER_BIT
)(
  input       i_clk,
  // input AXIS slave port
  output      o_s_axis_tready,
  input       i_s_axis_tvalid,
  input [7:0] i_s_axis_tdata, 
  // output serial data line
  output reg  o_txd,
  // output status signals
  output      o_txd_busy,
  output      o_txd_done
);
  
  parameter IDLE    = 3'b000;
  parameter START   = 3'b001;
  parameter TXDATA  = 3'b010;
  parameter STOP    = 3'b011;
  parameter PAUSE   = 3'b100;
   
  reg [2:0]    r_fsm_cs     = 0; // current state
  reg [7:0]    r_clk_count  = 0;
  reg [2:0]    r_bit_idx    = 0;
  reg [7:0]    r_tdata      = 0;
  reg          r_done       = 0;
  reg          r_busy       = 0;
     
  always @(posedge i_clk) begin
       
    case (r_fsm_cs)


      IDLE : begin
        o_txd       <= 1'b1; // Drive Line High for Idle
        r_done      <= 1'b0;
        r_clk_count <= 0;
        r_bit_idx   <= 0;

        if (i_s_axis_tvalid == 1'b1) begin
          r_tdata   <= i_s_axis_tdata;
          r_busy    <= 1'b1;
          r_fsm_cs  <= START;
        end else begin
          r_fsm_cs  <= IDLE;
          r_busy    <= 1'b0;
        end
      end  
         
         
      START : begin
        o_txd <= 1'b0;
         
        // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
        if (r_clk_count == CLKS_PER_BIT-1) begin
          r_clk_count <= 0;
          r_fsm_cs    <= TXDATA;
        end else begin
          r_clk_count <= r_clk_count + 1;
          r_fsm_cs    <= START;
        end 

      end  
         
                   
      TXDATA : begin           

        o_txd <= r_tdata[r_bit_idx];

        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish
        if (r_clk_count == CLKS_PER_BIT-1) begin
          r_clk_count <= 0;

          // send stop bit after all data bits done
          if (r_bit_idx == 7) begin
            r_fsm_cs  <= STOP;
            r_bit_idx <= 0;
          end else begin
            r_fsm_cs  <= TXDATA; 
            r_bit_idx <= r_bit_idx + 1;
          end

        end else begin
          r_fsm_cs    <= TXDATA;
          r_clk_count <= r_clk_count + 1;
        end
      end
         

      STOP : begin
        o_txd <= 1'b1;
         
        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        if (r_clk_count == CLKS_PER_BIT-1) begin
          r_fsm_cs    <= PAUSE;
          r_clk_count <= 0;
          r_done      <= 1'b1;
        end else begin
          r_fsm_cs    <= STOP;
          r_clk_count <= r_clk_count + 1;
        end

      end 


      // Stay here 1 clock
      PAUSE : begin
        r_done    <= 1'b1;
        r_fsm_cs  <= IDLE;
      end
      

      default : begin
        r_fsm_cs <= IDLE;
      end

    endcase
  end
 
  assign o_s_axis_tready = ~r_busy;
  assign o_txd_busy = r_busy;
  assign o_txd_done = r_done;
   
endmodule