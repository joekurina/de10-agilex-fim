# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Top-level pin and location assignments for DE10 Agilex
# Extracted from Terasic DE10 Agilex BSP (B2E2_8GBx4 variant) device.tcl
# Signal names adapted for OFS convention
#
#-----------------------------------------------------------------------------

#============================================================
# Clocks and Resets
#============================================================
# 100 MHz differential reference clock (feeds PCIe tile)
# Original BSP: config_clk
set_location_assignment PIN_DC22 -to SYS_REFCLK
set_instance_assignment -name IO_STANDARD "True Differential Signaling" -to SYS_REFCLK

# 50 MHz reference clock
# Original BSP: refclk
set_location_assignment PIN_G52 -to CLK_50M_FPGA
set_instance_assignment -name IO_STANDARD "1.2 V" -to CLK_50M_FPGA

# CPU reset (directly active-low from board)
# Original BSP: cpu_resetn
set_location_assignment PIN_G56 -to CPU_RESETN
set_instance_assignment -name IO_STANDARD "1.2 V" -to CPU_RESETN

#============================================================
# SI5397A Clock Synthesizer Control
#============================================================
set_location_assignment PIN_CT45 -to SI5397A_OE_n
set_location_assignment PIN_CU46 -to SI5397A_RST_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to SI5397A_OE_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to SI5397A_RST_n

#============================================================
# SPI (Board Info EEPROM)
#============================================================
set_location_assignment PIN_CU18 -to INFO_SPI_SCLK
set_location_assignment PIN_CV29 -to INFO_SPI_MISO
set_location_assignment PIN_CV17 -to INFO_SPI_MOSI
set_location_assignment PIN_CR18 -to INFO_SPI_CS_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to INFO_SPI_SCLK
set_instance_assignment -name IO_STANDARD "1.2 V" -to INFO_SPI_MISO
set_instance_assignment -name IO_STANDARD "1.2 V" -to INFO_SPI_MOSI
set_instance_assignment -name IO_STANDARD "1.2 V" -to INFO_SPI_CS_n

#============================================================
# PCIe Gen4 x16 (P-Tile)
# Original BSP: refclk_pcie_ch0_p/ch2_p, perstl0_n, pcie_ep_rx/tx_p/n[15:0]
# Note: Hardware supports Gen4; legacy BSP used Gen3 due to driver limitation
#============================================================
# Reference clocks (HCSL from PCIe slot)
set_location_assignment PIN_AJ48 -to PCIE_REFCLK0
set_location_assignment PIN_AE48 -to PCIE_REFCLK1
set_instance_assignment -name IO_STANDARD "HCSL" -to PCIE_REFCLK0
set_instance_assignment -name IO_STANDARD "HCSL" -to PCIE_REFCLK1

# Fundamental reset (active-low from PCIe slot)
set_location_assignment PIN_BU58 -to PCIE_RESET_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to PCIE_RESET_N

# RX lanes
set_location_assignment PIN_BP61 -to PCIE_RX_P[0]
set_location_assignment PIN_BN58 -to PCIE_RX_P[1]
set_location_assignment PIN_BK61 -to PCIE_RX_P[2]
set_location_assignment PIN_BJ58 -to PCIE_RX_P[3]
set_location_assignment PIN_BF61 -to PCIE_RX_P[4]
set_location_assignment PIN_BE58 -to PCIE_RX_P[5]
set_location_assignment PIN_BB61 -to PCIE_RX_P[6]
set_location_assignment PIN_BA58 -to PCIE_RX_P[7]
set_location_assignment PIN_AV61 -to PCIE_RX_P[8]
set_location_assignment PIN_AU58 -to PCIE_RX_P[9]
set_location_assignment PIN_AP61 -to PCIE_RX_P[10]
set_location_assignment PIN_AN58 -to PCIE_RX_P[11]
set_location_assignment PIN_AK61 -to PCIE_RX_P[12]
set_location_assignment PIN_AJ58 -to PCIE_RX_P[13]
set_location_assignment PIN_AF61 -to PCIE_RX_P[14]
set_location_assignment PIN_AE58 -to PCIE_RX_P[15]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to PCIE_RX_P

# TX lanes
set_location_assignment PIN_BP55 -to PCIE_TX_P[0]
set_location_assignment PIN_BN52 -to PCIE_TX_P[1]
set_location_assignment PIN_BK55 -to PCIE_TX_P[2]
set_location_assignment PIN_BJ52 -to PCIE_TX_P[3]
set_location_assignment PIN_BF55 -to PCIE_TX_P[4]
set_location_assignment PIN_BE52 -to PCIE_TX_P[5]
set_location_assignment PIN_BB55 -to PCIE_TX_P[6]
set_location_assignment PIN_BA52 -to PCIE_TX_P[7]
set_location_assignment PIN_AV55 -to PCIE_TX_P[8]
set_location_assignment PIN_AU52 -to PCIE_TX_P[9]
set_location_assignment PIN_AP55 -to PCIE_TX_P[10]
set_location_assignment PIN_AN52 -to PCIE_TX_P[11]
set_location_assignment PIN_AK55 -to PCIE_TX_P[12]
set_location_assignment PIN_AJ52 -to PCIE_TX_P[13]
set_location_assignment PIN_AF55 -to PCIE_TX_P[14]
set_location_assignment PIN_AE52 -to PCIE_TX_P[15]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to PCIE_TX_P

#============================================================
# Status LEDs (directly active-high from FPGA)
# Original BSP: FPGA_LED[3:0]
#============================================================
set_location_assignment PIN_CR54 -to FPGA_LED[0]
set_location_assignment PIN_DB57 -to FPGA_LED[1]
set_location_assignment PIN_CY57 -to FPGA_LED[2]
set_location_assignment PIN_CU52 -to FPGA_LED[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to FPGA_LED[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to FPGA_LED[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to FPGA_LED[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to FPGA_LED[3]

#============================================================
# QSFP-DD Port A - E-Tile HSSI (hssi_if[0-7])
# Directly connected to FPGA E-Tile transceivers
# Reference: Terasic DE10-Agilex User Manual & Golden_Top
# Channel mapping follows n6001 E-Tile quad organization
#============================================================
# Reference clock from SI5397A (156.25 MHz for 25GbE)
set_location_assignment PIN_AJ12 -to qsfp_ref_clk
set_location_assignment PIN_AH11 -to "qsfp_ref_clk(n)"
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL LVPECL" -to qsfp_ref_clk
set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_termination=enable_term" -to qsfp_ref_clk
set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_3p3v=disable_3p3v_tol" -to qsfp_ref_clk

# HSSI RX lanes (Port A) - n6001 E-Tile channel order
# Note: No explicit _n pin assignments - auto-inferred for HSSI
set_location_assignment PIN_BF7  -to hssi_if[0].rx_p
set_location_assignment PIN_BG10 -to hssi_if[1].rx_p
set_location_assignment PIN_BK7  -to hssi_if[2].rx_p
set_location_assignment PIN_BL10 -to hssi_if[3].rx_p
set_location_assignment PIN_BP7  -to hssi_if[4].rx_p
set_location_assignment PIN_BR10 -to hssi_if[5].rx_p
set_location_assignment PIN_BV7  -to hssi_if[6].rx_p
set_location_assignment PIN_BW10 -to hssi_if[7].rx_p

# HSSI TX lanes (Port A) - n6001 E-Tile channel order
set_location_assignment PIN_BF1  -to hssi_if[0].tx_p
set_location_assignment PIN_BG4  -to hssi_if[1].tx_p
set_location_assignment PIN_BK1  -to hssi_if[2].tx_p
set_location_assignment PIN_BL4  -to hssi_if[3].tx_p
set_location_assignment PIN_BP1  -to hssi_if[4].tx_p
set_location_assignment PIN_BR4  -to hssi_if[5].tx_p
set_location_assignment PIN_BV1  -to hssi_if[6].tx_p
set_location_assignment PIN_BW4  -to hssi_if[7].tx_p

# QSFP-DD Port A control signals
set_location_assignment PIN_DA20 -to qsfpa_resetn
set_location_assignment PIN_DB21 -to qsfpa_lpmode
set_location_assignment PIN_DB19 -to qsfpa_modeseln
set_location_assignment PIN_CV25 -to qsfpa_intn
set_location_assignment PIN_CT29 -to qsfpa_modprsln
set_location_assignment PIN_H21  -to qsfpa_i2c_scl
set_location_assignment PIN_H23  -to qsfpa_i2c_sda
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_resetn -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_lpmode -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_modeseln -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_intn -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_modprsln -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_i2c_scl -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpa_i2c_sda -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpa_resetn -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpa_lpmode -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpa_modeseln -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpa_i2c_scl -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpa_i2c_sda -entity top

# QSFP-DD Port B - E-Tile HSSI (reserved for future use with 16 channels)
# Reference clock
set_location_assignment PIN_AT13 -to qsfpb_ref_clk
set_location_assignment PIN_AP13 -to "qsfpb_ref_clk(n)"

# QSFP-DD Port B control signals (directly active, directly active active-low from board)
set_location_assignment PIN_CU22 -to qsfpb_resetn
set_location_assignment PIN_DA18 -to qsfpb_lpmode
set_location_assignment PIN_CR22 -to qsfpb_modeseln
set_location_assignment PIN_DC18 -to qsfpb_intn
set_location_assignment PIN_CY19 -to qsfpb_modprsln
set_location_assignment PIN_CY17 -to qsfpb_i2c_scl
set_location_assignment PIN_H19  -to qsfpb_i2c_sda
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_resetn -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_lpmode -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_modeseln -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_intn -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_modprsln -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_i2c_scl -entity top
set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpb_i2c_sda -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpb_resetn -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpb_lpmode -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpb_modeseln -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpb_i2c_scl -entity top
set_instance_assignment -name SLEW_RATE 0 -to qsfpb_i2c_sda -entity top

#============================================================
# Global Clock Assignments
#============================================================
set_instance_assignment -name GLOBAL_SIGNAL GLOBAL_CLOCK -to SYS_REFCLK
set_instance_assignment -name GLOBAL_SIGNAL GLOBAL_CLOCK -to CLK_50M_FPGA
