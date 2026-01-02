# OFS FIM for DE10-Agilex

I noticed that the DE10-Agilex is very similar to the n6001 card, so I made an attempt at porting it to OFS.
I used the old Terasic BSP for the OpenCL driver, the Schematic and Datasheet folders on the CD, and the DE10_Agilex_Golden_Top files as a reference.
Most of the work was pin-planning and I kinda guessed when it comes to PWRMGT.

There's a workaround in the mem_ss files: 
I inserted the DE10-Agilex's SODIMM DDR4 parameters into the IP presets. Ugly, but it works.

I cannot get the HSSI to work. Quartus can't seem to find the E-Tile and device_highspeed_tile is always empty. 
No IOPIPES in the OneAPI ASP, I guess.
If you can figure it out, submit a bug report or something.

This is just an experiment/learning exercise and I honestly don't know how well it works in practice. 
Tested a build in WSL2 running Almalinux-8 without errors, but there's a whole lot of warnings.
I have access to hardware and will play around with it in the coming months.

Use all of this at your own risk and let me know how it goes.

System Requirements:
- Almalinux/RockyLinux/RHEL 8.10 (9 is probably OK too. 8.8 is what OneAPI is validated on.)
- Quartus Prime Pro 24.1
- Quartus Patches 0.18 and 0.26, included in ofs-2024.2-1 release files
- OneAPI Base Toolkit 2025.0
- OneAPI FPGA Compiler Add-On 2025.0
- OPAE SDK
- A lot of free time...

```bash
# Enable EPEL and PowerTools repositories
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled powertools

# Install development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y cmake git python3 python3-devel python3-pip \
    json-c-devel libuuid-devel hwloc-devel \
    tbb-devel numactl-devel libcap-devel \
    python3-jsonschema python3-pyyaml \
    rpm-build rpmdevtools rsync libedit-devel

# Install kernel headers
sudo dnf install -y kernel-devel kernel-headers
```

Instructions:

```bash
# Create a workspace in the home folder
export OFS_WORKSPACE=~/ofs-de10-agilex
mkdir -p $OFS_WORKSPACE && cd $OFS_WORKSPACE

# Clone OFS Agilex PCIe Attach
git clone --branch ofs-2024.2-1 https://github.com/OFS/ofs-agx7-pcie-attach.git
cd ofs-agx7-pcie-attach
git submodule update --init --recursive

# Clone oneAPI ASP
cd $OFS_WORKSPACE
git clone --branch ofs-2024.2-1 https://github.com/OFS/oneapi-asp.git

# Clone PIM (Platform Interface Manager)
git clone --branch ofs-2024.2-1 https://github.com/OFS/ofs-platform-afu-bbb.git

git clone https://github.com/OPAE/intel-fpga-bbb.git
```

move the files in this repo into their respective folders in ~/ofs-agx7-pcie-attach/

source the ofs-env.sh file in this repo (make sure you add your Quartus Prime Pro license file)

```bash
cd $OFS_ROOTDIR

# Verify setup
quartus_sh --version
python3 --version

# Build FIM with PR enabled
./ofs-common/scripts/common/syn/build_top.sh -p de10-agilex work

# Output artifacts:
# work/syn/board/de10-agilex/syn_top/output_files/ofs_top.sof
# work/syn/board/de10-agilex/syn_top/output_files/ofs_top_page1.rbf
# work/syn/board/de10-agilex/pr_build_template/  (for ASP)
```

After that completes, it's time to build the OneAPI ASP:

```bash
# 1. Set up environment variables pointing to the FIM build artifacts
export OFS_ROOTDIR=~/ofs-de10-agilex/ofs-agx7-pcie-attach
export OPAE_PLATFORM_ROOT=$OFS_ROOTDIR/work/pr_build_template

# 2. Navigate to the ASP directory and make our scripts executable
cd ~/ofs-de10-agilex/oneapi-asp/
chmod +x common/scripts/*sh

# Clone the DE10-Agilex ASP files
git clone https://github.com/joekurina/de10-agilex.git
cd ~/ofs-de10-agilex/oneapi-asp/de10-agilex
chmod +x scripts/*.sh

# 3. Build the ASP (this builds MMD and generates platform files)
./scripts/build-asp.sh

# 4. After ASP build completes, create the flash image
# The FIM output files are in:
ls $OFS_ROOTDIR/work/syn/board/de10-agilex/syn_top/output_files/

# Then generate the USER flash image
cd $OFS_ROOTDIR/work/syn/board/de10-agilex/syn_top/build_flash/
./build_flash.sh

# Output files will be:
#   output_files/ofs_top_user.pof  - Flash image for USER page
#   output_files/ofs_top_user.cdf  - Programming file for quartus_pgm

# To program (on machine with JTAG connection):
# quartus_pgm -c 1 ../output_files/ofs_top_user.cdf

# Remember: Set SW6.0 = UP to boot from User page!
```

