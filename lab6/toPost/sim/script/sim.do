vlib work
vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../../src/alu.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/calculator.vhd
vcom -93 -work work ../src/calculator_tb.vhd
vsim -voptargs=+acc calculator_tb
do wave.do
run 3000 ns