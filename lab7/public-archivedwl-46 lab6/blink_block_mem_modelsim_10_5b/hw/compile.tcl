# Quartus II compile script for DE1-SoC board - lab 7 processor

# 1] name your project here
set project_name "lab7_processor"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/rom/blink_rom.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/components.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/synchronizer_8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/memory.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/alu.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/double_dabble.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/lab6/calculator.vhd
set_global_assignment -name VHDL_FILE ../../src/processor.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd

# 3] set your pin constraints here
# clock and buttons (KEY0 = reset_n, KEY1 = execute_n, both active low)
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset_n
set_location_assignment PIN_AA15 -to execute_n

# LEDR0..LEDR3 (led[2:0] = memory pointer, led[3] = 0)
set_location_assignment PIN_V16 -to led[0]
set_location_assignment PIN_W16 -to led[1]
set_location_assignment PIN_V17 -to led[2]
set_location_assignment PIN_V18 -to led[3]

# HEX0 (ones)
set_location_assignment PIN_AE26 -to bcd_0[0]
set_location_assignment PIN_AE27 -to bcd_0[1]
set_location_assignment PIN_AE28 -to bcd_0[2]
set_location_assignment PIN_AG27 -to bcd_0[3]
set_location_assignment PIN_AF28 -to bcd_0[4]
set_location_assignment PIN_AG28 -to bcd_0[5]
set_location_assignment PIN_AH28 -to bcd_0[6]

# HEX1 (tens)
set_location_assignment PIN_AJ29 -to bcd_1[0]
set_location_assignment PIN_AH29 -to bcd_1[1]
set_location_assignment PIN_AH30 -to bcd_1[2]
set_location_assignment PIN_AG30 -to bcd_1[3]
set_location_assignment PIN_AF29 -to bcd_1[4]
set_location_assignment PIN_AF30 -to bcd_1[5]
set_location_assignment PIN_AD27 -to bcd_1[6]

# HEX2 (hundreds)
set_location_assignment PIN_AB23 -to bcd_2[0]
set_location_assignment PIN_AE29 -to bcd_2[1]
set_location_assignment PIN_AD29 -to bcd_2[2]
set_location_assignment PIN_AC28 -to bcd_2[3]
set_location_assignment PIN_AD30 -to bcd_2[4]
set_location_assignment PIN_AC29 -to bcd_2[5]
set_location_assignment PIN_AC30 -to bcd_2[6]

execute_flow -compile
project_close