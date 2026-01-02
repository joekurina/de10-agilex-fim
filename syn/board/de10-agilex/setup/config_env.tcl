# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Build environment configuration for DE10 Agilex
# Sets up the BUILD_ROOT_REL variable used by other TCL scripts
#
#-----------------------------------------------------------------------------

# Set up the build root path relative to the synthesis directory
if {![info exists ::env(BUILD_ROOT_REL)]} {
    # Determine the path relative to this script location
    set script_dir [file dirname [info script]]
    set ::env(BUILD_ROOT_REL) [file normalize [file join $script_dir ".." ".." ".." ".."]]
}

post_message "BUILD_ROOT_REL set to: $::env(BUILD_ROOT_REL)"

# Board-specific settings for DE10 Agilex
# These can be referenced by other TCL scripts

# Platform name (used for OFSS config lookup)
set ::env(OFS_PLATFORM) "de10-agilex"

# Device part number
set ::env(OFS_DEVICE) "AGFB014R24B2E2V"

# Number of DDR4 channels
set ::env(OFS_NUM_MEM_CH) "4"

# PCIe configuration (Gen4 x16)
set ::env(OFS_PCIE_GEN) "4"
set ::env(OFS_PCIE_WIDTH) "16"
