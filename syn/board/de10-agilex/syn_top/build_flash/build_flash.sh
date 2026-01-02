#!/bin/bash
# Copyright (C) 2025
# SPDX-License-Identifier: MIT
#
# DE10-Agilex Flash Image Generation Script
# Generates POF file for CFI flash programming via MAX10 system controller
#
# Flash Architecture:
#   - 128MB (1Gbit) CFI Flash connected to MAX10 system controller
#   - JTAG Chain: Agilex (AGFB014R24B2E2V) -> MAX10 (10M08SC)
#   - User page only: 0x038C0000 (Factory page is NEVER touched)
#
# IMPORTANT: This script ONLY programs the USER page.
#            The FACTORY page must NEVER be overwritten.
#            Set SW6.0 = UP to boot from User page.

SOF_FILE="ofs_top.sof"
AGILEX_DEVICE="AGFB014R24B2E2V"
MAX10_DEVICE="10M08SC"
FLASH_TYPE="CFI_1GB"

# Flash memory map (DE10-Agilex specific) - matches flash.pl exactly
PAGE0_ADDR="0x00040000"      # Factory image location (NEVER TOUCH)
PAGE1_ADDR="0x038C0000"      # User image location
OPTION_OFFSET="0x00030000"

# This script assumes CWD is the build_flash directory
LOCAL_SCRIPT_DIR=$(realpath .)
OUTPUT_DIR="${LOCAL_SCRIPT_DIR}/../output_files"

echo "=== DE10-Agilex Flash Image Generation ==="
echo "Flash type: ${FLASH_TYPE}"
echo "JTAG chain: ${AGILEX_DEVICE} -> ${MAX10_DEVICE}"
echo "Target: USER page ONLY (Factory page is protected)"
echo ""

# Check for SOF file
if [ ! -e "${OUTPUT_DIR}/${SOF_FILE}" ]; then
    echo "Error: Cannot find ${SOF_FILE} in output_files/"
    exit 1
fi

echo "Found ${SOF_FILE}"
echo "Generating POF for USER page only..."

# Generate PFG file - USER PAGE ONLY
PFG_FILE="${LOCAL_SCRIPT_DIR}/ofs_top_user.pfg"
POF_FILE="ofs_top_user.pof"

cat > "${PFG_FILE}" << PFGEOF
<pfg version="1">
    <settings custom_db_dir="./" mode="AVSTX16"/>
    <output_files>
        <output_file name="${POF_FILE%.pof}" directory="${OUTPUT_DIR}" type="POF">
            <file_options/>
            <secondary_file type="MAP" name="${POF_FILE%.pof}">
                <file_options/>
            </secondary_file>
            <flash_device_id>Flash_Device_1</flash_device_id>
        </output_file>
    </output_files>
    <bitstreams>
        <bitstream id="Bitstream_1">
            <path>${OUTPUT_DIR}/${SOF_FILE}</path>
        </bitstream>
        <bitstream id="Bitstream_2">
            <path>${OUTPUT_DIR}/${SOF_FILE}</path>
        </bitstream>
    </bitstreams>
    <flash_devices>
        <flash_device type="CFI_1Gb" id="Flash_Device_1">
            <partition reserved="1" fixed_s_addr="0" s_addr="${OPTION_OFFSET}" e_addr="auto" fixed_e_addr="0" id="OPTIONS" size="0"/>
            <partition reserved="0" fixed_s_addr="0" s_addr="${PAGE0_ADDR}" e_addr="auto" fixed_e_addr="0" id="Factory_HW" size="0"/>
            <partition reserved="0" fixed_s_addr="0" s_addr="${PAGE1_ADDR}" e_addr="auto" fixed_e_addr="0" id="User_HW" size="0"/>
        </flash_device>
    </flash_devices>
    <assignments>
        <assignment page="0" partition_id="Factory_HW">
            <bitstream_id>Bitstream_1</bitstream_id>
        </assignment>
        <assignment page="1" partition_id="User_HW">
            <bitstream_id>Bitstream_2</bitstream_id>
        </assignment>
    </assignments>
</pfg>
PFGEOF

echo "Generated PFG file: ${PFG_FILE}"

# Generate POF using quartus_pfg
quartus_pfg -c "${PFG_FILE}"
if [ $? -ne 0 ]; then
    echo "Error: POF generation failed"
    exit 1
fi

# Generate CDF file for programming USER page ONLY
CDF_USER="${OUTPUT_DIR}/ofs_top_user.cdf"
cat > "${CDF_USER}" << CDFEOF
JedecChain;
    FileRevision(JESD32A);
    DefaultMfr(6E);
    
    P ActionCode(Ign)
        Device PartName(${AGILEX_DEVICE}) MfrSpec(OpMask(0));
    P ActionCode(Ign)
        Device PartName(${MAX10_DEVICE}) MfrSpec(OpMask(0) SEC_Device(${FLASH_TYPE}) Child_OpMask(4 0 0 1 1) PFLPath("${OUTPUT_DIR}/${POF_FILE}"));
ChainEnd;

AlteraBegin;
    ChainType(JTAG);
AlteraEnd;
CDFEOF

echo ""
echo "=== Flash image generation complete ==="
echo ""
echo "Output files:"
echo "  SOF (JTAG volatile):     ${OUTPUT_DIR}/${SOF_FILE}"
echo "  POF (User flash):        ${OUTPUT_DIR}/${POF_FILE}"
echo "  CDF (User page):         ${CDF_USER}"
echo ""
echo "Programming commands:"
echo ""
echo "  # JTAG volatile (lost on power cycle):"
echo "  quartus_pgm -c 1 -m jtag -o \"p;${OUTPUT_DIR}/${SOF_FILE}@1\""
echo ""
echo "  # Flash to USER page (set SW6.0 = UP to boot from User):"
echo "  quartus_pgm -c 1 ${CDF_USER}"
echo ""
echo "WARNING: Factory page is NEVER touched by this script."
echo ""

exit 0
