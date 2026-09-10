vlib work
vcom -93 -work work ../../src/full_adder_single_bit_arch.vhd
vcom -93 -work work ../src/full_adder_single_bit_arch_tb.vhd
vsim -voptargs=+acc full_adder_single_bit_arch_tb
do wave.do
run 100 ns
