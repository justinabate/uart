onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group uart_rx_wrap /uart_tb/i_uart_rx_wrap/i_clk
add wave -noupdate -expand -group uart_rx_wrap /uart_tb/i_uart_rx_wrap/i_rst_n
add wave -noupdate -expand -group uart_rx_wrap /uart_tb/i_uart_rx_wrap/i_rxd
add wave -noupdate -expand -group uart_rx_wrap {/uart_tb/i_uart_rx_wrap/i_uart_rx/r_rxd_sync[1]}
add wave -noupdate -expand -group uart_rx_wrap /uart_tb/i_uart_rx_wrap/i_uart_rx/r_sample_valid
add wave -noupdate -expand -group uart_rx_wrap -group fifo /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/i_clk
add wave -noupdate -expand -group uart_rx_wrap -group fifo /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/i_rst_n
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {write port} /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/i_wena
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {write port} /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_werr
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {write port} -radix hexadecimal -radixshowbase 1 /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/i_wdat
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {read port} /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/i_rena
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {read port} /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_rerr
add wave -noupdate -expand -group uart_rx_wrap -group fifo -expand -group {read port} -radix hexadecimal -radixshowbase 1 /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_rdat
add wave -noupdate -expand -group uart_rx_wrap -group fifo /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_empt
add wave -noupdate -expand -group uart_rx_wrap -group fifo -radix unsigned /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_flvl
add wave -noupdate -expand -group uart_rx_wrap -group fifo /uart_tb/i_uart_rx_wrap/genblk1/i_fifo/o_full
add wave -noupdate -expand -group uart_rx_wrap -expand -group {M AXIS output} /uart_tb/i_uart_rx_wrap/i_m_axis_tready
add wave -noupdate -expand -group uart_rx_wrap -expand -group {M AXIS output} /uart_tb/i_uart_rx_wrap/o_m_axis_tvalid
add wave -noupdate -expand -group uart_rx_wrap -expand -group {M AXIS output} -radix hexadecimal -radixshowbase 1 /uart_tb/i_uart_rx_wrap/o_m_axis_tdata
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/i_clk
add wave -noupdate -expand -group uart_tx -expand -group {S AXIS input} /uart_tb/i_uart_tx/o_s_axis_tready
add wave -noupdate -expand -group uart_tx -expand -group {S AXIS input} /uart_tb/i_uart_tx/i_s_axis_tvalid
add wave -noupdate -expand -group uart_tx -expand -group {S AXIS input} -radix hexadecimal -radixshowbase 1 /uart_tb/i_uart_tx/i_s_axis_tdata
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/r_fsm_cs
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd_busy
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd
add wave -noupdate -expand -group uart_tx /uart_tb/i_uart_tx/o_txd_done
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/i_clk
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/i_rxd
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/r_fsm_cs
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/r_sample_valid
add wave -noupdate -expand -group uart_rx_checker -radix hexadecimal /uart_tb/i_uart_rx_1/o_m_axis_tdata
add wave -noupdate -expand -group uart_rx_checker /uart_tb/i_uart_rx_1/o_m_axis_tvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {174651279200 fs} 0} {{Cursor 2} {31648763802 fs} 0}
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
WaveRestoreZoom {0 fs} {224023962516 fs}
