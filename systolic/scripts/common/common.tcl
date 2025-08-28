
##########  VARIABLES TO MODIFY ############################################################################# Main_PATH
set ROOT_DIR        "/home/ICer/systolic"
set DESIGN_REF_PATH "/home/ICer/PDK/SAED14_EDK"


set VERILOG_DIR     "/home/ICer/systolic/rtl"

###########################################################

set DESIGN_NAME     "systolic_array"
set Constraints_file      "/home/ICer/systolic/cons/cons_v2.tcl"
set Core_compile          "/home/ICer/systolic/output/${DESIGN_NAME}.v"
set Warning_file          "/home/ICer/common/warnings_to_ignore.tcl"
############### outputs 
set Svf_file              "${ROOT_DIR}/results/${DESIGN_NAME}.svf"
set ARC_TOP               "${ROOT_DIR}/results/${DESIGN_NAME}.ndm"
set Top_design_pt         "${ROOT_DIR}/results/${DESIGN_NAME}_pt.v"
###########################################################

set pns_vlayer M7
set pns_hlayer M6
set route_min_layer M2
set route_max_layer M5


#################################################################################REF_PATH
set DESIGN_REF_LIB_PATH  "${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT"
set DESIGN_REF_TECH_PATH "${DESIGN_REF_PATH}/SAED14nm_EDK_TECH_DATA"
#################################################################################LIB_PATH
set DESIGN_REF_MW_PATH   "${DESIGN_REF_TECH_PATH}/SAED14nm_EDK_STD_LVT/milkyway"
set DESIGN_REF_RC_PATH   "${DESIGN_REF_TECH_PATH}/tlup"
set DESIGN_REF_NXTGRD_PATH   "${DESIGN_REF_TECH_PATH}/nxtgrd"
#################################################################################TECH_PATH
set DESIGN_REF_NLDM_PATH "${DESIGN_REF_LIB_PATH}/liberty/nldm/base"
set DESIGN_REF_RAM_PATH  "${DESIGN_REF_LIB_PATH}/sram/logic_synth/single" ; #ff
#######################################################################################Liberty
set Std_cell_lib         "${DESIGN_REF_NLDM_PATH}/saed14lvt_base_tt0p8v25c.db"
set Ram_lib              "${DESIGN_REF_RAM_PATH}/saed14sram_tt0p8v25c.db" ; #ff
#######################################################################################
#set REFERENCE_LIB "${DESIGN_REF_LIB_PATH}/ndm/saed14rvt_frame_only.ndm \
#                            ${DESIGN_REF_LIB_PATH}/sram/ndm/saed14_sram_1rw_frame_only.ndm" ; #ff
set REFERENCE_LIB "${DESIGN_REF_LIB_PATH}/ndm/saed14lvt_frame_only.ndm" ; #ff

set Std_cell_gds	"${DESIGN_REF_LIB_PATH}/gds/saed14lvt.gds"
#set search_path "$DESIGN_REF_RC_PATH $DESIGN_REF_NLDM_PATH $DESIGN_REF_RAM_PATH"

set Tech_file             "${DESIGN_REF_TECH_PATH}/tf/saed14nm_1p9m.tf"
set Map_file              "${DESIGN_REF_TECH_PATH}/map/saed14nm_tf_itf_tluplus.map"
#set Antenna_file          "${DESIGN_REF_MW_PATH}/saed32nm_ant_1p9m.tcl"
#set Alf_file              "${DESIGN_REF_MW_PATH}/saed32nm_em_1p9m.alf"
set Gds_map_file          "${DESIGN_REF_TECH_PATH}/map/saed14nm_1p9m_gdsout.map"
set Tlup_max_file         "${DESIGN_REF_RC_PATH}/saed14nm_1p9m_Cmax.tlup"
set Tlup_min_file         "${DESIGN_REF_RC_PATH}/saed14nm_1p9m_Cmin.tlup"
set Nxtgrd_max_file       "${DESIGN_REF_NXTGRD_PATH}/saed14nm_1p9m_Cmax.nxtgrd"
set Nxtgrd_min_file       "${DESIGN_REF_NXTGRD_PATH}/saed14nm_1p9m_Cmin.nxtgrd"

set icv_drc_runset	  "${DESIGN_REF_TECH_PATH}/icv_drc/saed14nm_1p9m_drc_rules.rs"
#set icv_drc_runset "${DESIGN_REF_MW_PATH}/saed14nm_1p9m_mw.tf"
set icv_mfill_runset      "${DESIGN_REF_TECH_PATH}/icv_drc/saed14nm_1p9m_mfill_rules.rs"
###########################################################

set analyze_script "${ROOT_DIR}/common/analyze_script.tcl"
###########################################################

