onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/i_clk
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/i_rst_n
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/i_rxd
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/i_m_axis_tready
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/o_m_axis_tvalid
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/o_m_axis_tdata
add wave -noupdate -expand -group inst_uart_rx_wrap /uart_tb/inst_uart_rx_wrap/o_rxd_busy
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/i_clk
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/i_arst_n
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/o_s_axis_tready
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/i_s_axis_tvalid
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/i_s_axis_tdata
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/i_s_axis_thold
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/o_txd
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/o_txd_busy
add wave -noupdate -expand -group inst_uart_tx_wrap /uart_tb/inst_uart_tx_wrap/o_txd_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {129493307839 fs} 0} {{Cursor 2} {97772466539 fs} 0}
quietly wave cursor active 2
configure wave -namecolwidth 183
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 fs} {274864327500 fs}
