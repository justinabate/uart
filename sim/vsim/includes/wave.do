onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group uart_rx /uart_tb/i_uart_rx_0/i_clk
add wave -noupdate -expand -group uart_rx /uart_tb/i_uart_rx_0/i_rxd
add wave -noupdate -expand -group uart_rx /uart_tb/i_uart_rx_0/r_fsm_cs
add wave -noupdate -expand -group uart_rx /uart_tb/i_uart_rx_0/r_sample_valid
add wave -noupdate -expand -group uart_rx -radix hexadecimal /uart_tb/i_uart_rx_0/o_m_axis_tdata
add wave -noupdate -expand -group uart_rx /uart_tb/i_uart_rx_0/o_m_axis_tvalid
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/i_clk
add wave -noupdate -expand -group uart_tx -radix hexadecimal /uart_tb/i_uart_tx/i_s_axis_tdata
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/i_s_axis_tvalid
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/r_fsm_cs
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_s_axis_tready
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd_busy
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd_done
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/i_clk
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/i_rxd
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/r_fsm_cs
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/r_sample_valid
add wave -noupdate -expand -group uart_rx_checker -radix hexadecimal /uart_tb/i_uart_rx_1/o_m_axis_tdata
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/o_m_axis_tvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {179115550 ps} 0} {{Cursor 2} {78249970 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {195457500 ps}
