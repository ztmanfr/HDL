vlib work
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/generic_add_sub.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/add_sub_state_machine.vhd
vcom -93 -work work ../src/double_dabble_tb.vhd
vsim -voptargs=+acc double_dabble_tb
do wave.do
run 5000 ns