############################################################
#################	Parameters	####################
############################################################
set CLK_PERIOD 1.00


set UNCERTAINTY_SETUP  0.03

set UNCERTAINTY_HOLD  0.03

set CLOCK_TRANSITION 0.05

set INPUT_DELAY  [expr 0.05*$CLK_PERIOD]
set OUTPUT_DELAY [expr 0.05*$CLK_PERIOD]

#################   Clock Constraints   ####################
############################################################

create_clock -name clk -period $CLK_PERIOD [get_ports clk] 

## clock transition
set_clock_transition $CLOCK_TRANSITION [get_clocks clk]


set_clock_uncertainty -setup $UNCERTAINTY_SETUP  [all_clocks]
set_clock_uncertainty -hold $UNCERTAINTY_HOLD [all_clocks]

##################################################################
#################   environment constraints   ####################
##################################################################
## input & output delays

set_input_delay $INPUT_DELAY -clock [get_clocks clk] [remove_from_collection [all_inputs] [get_ports clk]]

set_output_delay $OUTPUT_DELAY -clock [get_clocks clk] [get_ports matrix_c_out]
set_output_delay $OUTPUT_DELAY -clock [get_clocks clk] [get_ports valid_out]


## outside environment

set_driving_cell -library saed14lvt_base_tt0p8v25c -lib_cell SAEDLVT14_BUF_S_20 -pin X [all_inputs]

set_load 0.01 [all_outputs]

group_path -name INREG -from [all_inputs]
group_path -name REGOUT -to [all_outputs]
group_path -name INOUT -from [all_inputs] -to [all_outputs]
group_path -name REG2REG -from [all_registers] -to [all_registers]





