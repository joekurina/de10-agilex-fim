#!/bin/bash
# OFS DE10 Agilex Build Environment

# Quartus
export QUARTUS_ROOTDIR=/opt/intelFPGA_pro/24.1/quartus
export QUARTUS_HOME=$QUARTUS_ROOTDIR
export PATH=$QUARTUS_ROOTDIR/bin:$PATH
export PATH=$QUARTUS_ROOTDIR/bin:$QUARTUS_ROOTDIR/../qsys/bin:$PATH
export LM_LICENSE_FILE=

# OFS
export OFS_WORKSPACE=~/ofs-de10-agilex
export OFS_ROOTDIR=$OFS_WORKSPACE/ofs-agx7-pcie-attach
export OFS_BUILD_ROOT=$OFS_ROOTDIR
export OFS_BOARD_CORE=de10-agilex
export WORK_DIR=work

# Bitstream Metadata
export BITSTREAM_ID=0001DE10AF000001
export BITSTREAM_MD=0000000020251231
export BITSTREAM_INFO=0000DE10F1400001


# OPAE
export OPAE_SDK_ROOT=/usr/local
export LIBOPAE_C_ROOT=/usr/local
export OPAE_PLATFORM_ROOT=$OFS_ROOTDIR/work/pr_build_template

# PIM
export OFS_PLATFORM_AFU_BBB=$OFS_WORKSPACE/ofs-platform-afu-bbb

# oneAPI ASP
export OFS_ASP_ROOT=$OFS_WORKSPACE/oneapi-asp/de10-agilex

# oneAPI (if installed)
source /opt/intel/oneapi/setvars.sh