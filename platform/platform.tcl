# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/akira/work/ultra96v2/vitis_work/wksp1/ultra96v2-platform/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/akira/work/ultra96v2/vitis_work/wksp1/ultra96v2-platform/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {ultra96v2_platform}\
-hw {/home/akira/work/ultra96v2/xsa_dir/ultra96v2_4z/ultra96v2_4z.xsa}\
-proc {psu_cortexa53} -os {linux} -arch {64-bit} -no-boot-bsp -fsbl-target {psu_cortexa53_0} -out {.}

platform write
platform active {ultra96v2_platform}
domain config -bif {/home/akira/work/ultra96v2/vitis_args/linux.bif}
platform write
domain config -boot {/home/akira/work/ultra96v2/boot}
platform write
domain config -image {/home/akira/work/ultra96v2/boot}
platform write
domain config -rootfs {/home/akira/work/ultra96v2/petalinux/build/tmp/deploy/images/ultra96v2-zynqmp/petalinux-image-minimal-ultra96v2ros2-ultra96v2-zynqmp.ext4}
platform write
domain config -sysroot {/home/akira/work/ultra96v2/sdk/sysroots/aarch64-xilinx-linux}
platform write
domain config -qemu-data {/home/akira/work/ultra96v2/vitis_args}
platform write
domain config -qemu-data {/home/akira/work/ultra96v2/boot}
platform write
domain config -qemu-args {/home/akira/work/ultra96v2/vitis_args/qemu_args.txt}
platform write
domain config -pmuqemu-args {/opt/Xilinx/Vitis/2020.2/data/emulation/platforms/zynqmp/sw/a53_linux/qemu/pmu_args.txt}
platform write
domain config -pmuqemu-args {/home/akira/work/ultra96v2/vitis_args/pmu_args.txt}
platform write
domain config -qemu-data {/home/akira/work/ultra96v2/petalinux/build/tmp/deploy/images/ultra96v2-zynqmp}
platform write
platform generate
