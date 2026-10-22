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
<<<<<<< HEAD
add wave -noupdate /double_dabble_tb/reset
add wave -noupdate /double_dabble_tb/switch
add wave -noupdate /double_dabble_tb/btn
add wave -noupdate /double_dabble_tb/led
add wave -noupdate /double_dabble_tb/uut/state_reg
add wave -noupdate -radix unsigned /double_dabble_tb/uut/aval
add wave -noupdate -radix unsigned /double_dabble_tb/uut/bval
add wave -noupdate -radix unsigned /double_dabble_tb/uut/res
add wave -noupdate /double_dabble_tb/uut/result_padded
add wave -noupdate -radix unsigned /double_dabble_tb/uut/hun
add wave -noupdate -radix unsigned /double_dabble_tb/uut/ten
add wave -noupdate -radix unsigned /double_dabble_tb/uut/one
add wave -noupdate -radix States /double_dabble_tb/bcd_2
add wave -noupdate -radix States /double_dabble_tb/bcd_1
add wave -noupdate -radix States /double_dabble_tb/bcd_0
=======
add wave -noupdate -radix decimal /double_dabble_tb/uut/result_padded
add wave -noupdate -radix decimal /double_dabble_tb/uut/ones
add wave -noupdate -radix decimal /double_dabble_tb/uut/tens
add wave -noupdate -radix decimal /double_dabble_tb/uut/hundreds
add wave -noupdate -radix decimal /double_dabble_tb/uut/clk
add wave -noupdate -radix decimal /double_dabble_tb/uut/reset
add wave -noupdate -radix decimal /double_dabble_tb/uut/btn

>>>>>>> 1ab6a95aa02ffd46c90bee7d9df2f67c267cd031
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
WaveRestoreZoom {0 ps} {5000 ns}