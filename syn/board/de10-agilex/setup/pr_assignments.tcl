# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Partial Reconfiguration (PR) region assignments for DE10 Agilex
# Uses original Terasic BSP PR region coordinates from base.qsf
#
#-----------------------------------------------------------------------------

if { [info exist env(OFS_BUILD_TAG_FLAT) ] } { 
    post_message "Compiling Flat design..." 
} else {

    if { [info exist env(OFS_BUILD_TAG_PR_FLOORPLAN) ] } {
        set fp_tcl_file_name  [exec basename $env(OFS_BUILD_TAG_PR_FLOORPLAN)]
        post_message "Compiling User Specified PR Base floorplan $fp_tcl_file_name"
    
        if { [file exists $::env(BUILD_ROOT_REL)/syn/user_settings/$fp_tcl_file_name] == 0} {
            post_message "Warning User PR floorplan not found = /syn/user_settings/$fp_tcl_file_name"
        }
        
        set_global_assignment -name SOURCE_TCL_SCRIPT_FILE $::env(BUILD_ROOT_REL)/syn/user_settings/$fp_tcl_file_name
         
    } else {
        post_message "Compiling PR Base revision..." 
        
        #-------------------------------
        # Specify PR Partition and turn PR ON for that partition
        #-------------------------------
        set_global_assignment -name REVISION_TYPE PR_BASE
        
        #####################################################
        # Main PR Partition -- green_region (AFU slot)
        #####################################################
        set_instance_assignment -name PARTITION green_region -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name RESERVE_PLACE_REGION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name PARTIAL_RECONFIGURATION_PARTITION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
    
        #####################################################
        # PR region floorplan for DE10 Agilex
        # Device: AGFB014R24B2E2V
        # Coordinates from original Terasic BSP base.qsf:
        #   PLACE_REGION "X166 Y3 X331 Y207;X42 Y20 X165 Y190"
        #   ROUTE_REGION "0 0 331 207"
        #####################################################
        set_instance_assignment -name PLACE_REGION "X166 Y3 X331 Y207; X42 Y20 X165 Y190" -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name ROUTE_REGION "X0 Y0 X331 Y207" -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        
        #####################################################
        # Static region placement constraints
        # Place FIM infrastructure in the left side of the device
        #####################################################
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|tag_remap
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|tag_remap
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pf_vf_mux_a
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|pf_vf_mux_a
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pf_vf_mux_b
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|pf_vf_mux_b
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|mx2ho_tx_ab_mux
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|mx2ho_tx_ab_mux
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|afu_intf_inst
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|afu_intf_inst
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|fim_afu_instances|st2mm
        set_instance_assignment -name PLACE_REGION "X0 Y0 X41 Y207" -to afu_top|fim_afu_instances|st2mm
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|fim_afu_instances|he_lb_top
        set_instance_assignment -name PLACE_REGION "X0 Y190 X165 Y207" -to afu_top|fim_afu_instances|he_lb_top
    }

}
