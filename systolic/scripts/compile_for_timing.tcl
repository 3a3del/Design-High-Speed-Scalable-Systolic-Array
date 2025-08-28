
source /home/ICer/systolic/scripts/common/common.tcl

set_svf sys.svf

set link_library          "* $Std_cell_lib" 
set target_library        " $Std_cell_lib"
set dc_allow_rtl_pg	  true
set compile_top_all_paths true

source $analyze_script
elaborate ${DESIGN_NAME} -architecture verilog -library WORK

current_design ${DESIGN_NAME}

link

source $Constraints_file

set_fix_multiple_port_nets -outputs -feedthroughs 
source $Warning_file

check_design
link

compile -exact_map -map_effort high -area_effort medium -power_effort none 

set_svf -off

## reporting and output
report_timing > ${DESIGN_NAME}_timing_reports.log
report_timing -delay_type min  > ${DESIGN_NAME}_timing_min_reports_.log 
report_timing -max_paths 20 > ${DESIGN_NAME}_timing_max_reports_.log 
report_qor > ${DESIGN_NAME}_qor_reports_.log
report_area -hierarchy  > ${DESIGN_NAME}_area_reports_.log
report_power -hierarchy > ${DESIGN_NAME}_power_reports_.log
write_sdc ${DESIGN_NAME}.sdc
change_names -rules verilog
write_file -format verilog -hierarchy -pg -output ${DESIGN_NAME}.v

#quit
