quit -sim
vlib work
vmap work work

# rom (blink_rom, 10 bits wide, loads blink.mif)
vcom -93 -work work ../../src/rom/blink_rom.vhd

# lab 6 files (unchanged) - adjust names/paths to match your project
vcom -93 -work work ../../src/lab6/components.vhd
vcom -93 -work work ../../src/lab6/synchronizer_8bit.vhd
vcom -93 -work work ../../src/lab6/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/lab6/memory.vhd
vcom -93 -work work ../../src/lab6/alu.vhd
vcom -93 -work work ../../src/lab6/double_dabble.vhd
vcom -93 -work work ../../src/lab6/seven_seg.vhd

# lab 7 files
vcom -93 -work work ../../src/processor.vhd
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../src/top_tb.vhd

vsim -voptargs=+acc work.top_tb

add wave -divider {inputs}
add wave /top_tb/clk
add wave /top_tb/reset_n
add wave /top_tb/execute_n
add wave -divider {fetch}
add wave /top_tb/uut/u_proc/exec_edge
add wave -radix unsigned /top_tb/uut/u_proc/pc
add wave -radix binary   /top_tb/uut/u_proc/instr
add wave -divider {datapath}
add wave -radix unsigned /top_tb/uut/u_proc/addr_ptr
add wave -radix unsigned /top_tb/uut/u_proc/mem_dout
add wave -radix unsigned /top_tb/uut/u_proc/alu_result
add wave /top_tb/uut/u_proc/write_en
add wave -radix unsigned /top_tb/uut/u_proc/result_reg
add wave -divider {outputs}
add wave /top_tb/led
add wave /top_tb/bcd_2
add wave /top_tb/bcd_1
add wave /top_tb/bcd_0

run 8 us
wave zoom full