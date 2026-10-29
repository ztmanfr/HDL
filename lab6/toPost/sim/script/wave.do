onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    "7'b1111111" "-" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /calculator_tb/reset
add wave -noupdate /calculator_tb/execute
add wave -noupdate -radix unsigned /calculator_tb/switch
add wave -noupdate /calculator_tb/op
add wave -noupdate /calculator_tb/led
add wave -noupdate /calculator_tb/uut/addr_ptr
add wave -noupdate /calculator_tb/uut/next_addr
add wave -noupdate -radix unsigned /calculator_tb/uut/switch_sync
add wave -noupdate /calculator_tb/uut/op_sync
add wave -noupdate -radix unsigned /calculator_tb/uut/mem_dout
add wave -noupdate -radix unsigned /calculator_tb/uut/alu_result
add wave -noupdate -radix unsigned /calculator_tb/uut/dd_hundreds
add wave -noupdate -radix unsigned /calculator_tb/uut/dd_tens
add wave -noupdate -radix unsigned /calculator_tb/uut/dd_ones
add wave -noupdate -radix States /calculator_tb/bcd_2
add wave -noupdate -radix States /calculator_tb/bcd_1
add wave -noupdate -radix States /calculator_tb/bcd_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 60
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3000 ns}