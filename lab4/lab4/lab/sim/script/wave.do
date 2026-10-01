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
    "7'b0001000" "A" -color "red",
    "7'b0000011" "b" -color "red",
    "7'b1000110" "C" -color "red",
    "7'b0100001" "d" -color "red",
    "7'b0000110" "E" -color "red",
    "7'b0001110" "F" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /add_sub_tb/clk
add wave -noupdate /add_sub_tb/reset
add wave -noupdate -radix unsigned /add_sub_tb/a
add wave -noupdate -radix unsigned /add_sub_tb/b
add wave -noupdate -color Orange /add_sub_tb/add_btn
add wave -noupdate -color Orange /add_sub_tb/sub_btn
add wave -noupdate -radix unsigned /add_sub_tb/uut/a_sync
add wave -noupdate -radix unsigned /add_sub_tb/uut/b_sync
add wave -noupdate -color Orange /add_sub_tb/uut/ensel
add wave -noupdate -radix unsigned /add_sub_tb/uut/fin_result
add wave -noupdate -radix unsigned /add_sub_tb/uut/result_reg
add wave -noupdate -radix States /add_sub_tb/a_bcd
add wave -noupdate -radix States /add_sub_tb/b_bcd
add wave -noupdate -radix States /add_sub_tb/result_bcd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1920000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {3332983 ps}
