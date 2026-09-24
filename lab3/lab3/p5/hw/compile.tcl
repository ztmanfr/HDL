# Quartus II compile script for DE1-SoC board (counter)

set project_name "counter"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# source files (relative to hw/project)
set_global_assignment -name VHDL_FILE ../../src/top.vhd
set_global_assignment -name VHDL_FILE ../../src/seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_adder_beh.vhd

# pins: reset = SW0, clk = 50 MHz, HEX0 segments (verify against DE1-SoC manual)
set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AE26 -to {seven_seg_out[0]}
set_location_assignment PIN_AE27 -to {seven_seg_out[1]}
set_location_assignment PIN_AE28 -to {seven_seg_out[2]}
set_location_assignment PIN_AG27 -to {seven_seg_out[3]}
set_location_assignment PIN_AF28 -to {seven_seg_out[4]}
set_location_assignment PIN_AG28 -to {seven_seg_out[5]}
set_location_assignment PIN_AH28 -to {seven_seg_out[6]}

execute_flow -compile
project_close