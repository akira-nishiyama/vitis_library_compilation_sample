cmake_minimum_required(VERSION 3.1)

project(vecadd_lib_sample
    VERSION 1.0
    LANGUAGES C CXX)

set(BUILD_TARGET "hw" CACHE STRING "build target. valid:sw_emu,hw_emu,hw")
message(STATUS "BUILD_TARGET:${BUILD_TARGET}")
set(ROOTFS "/home/akira/work/ultra96v2/vitis_work/wksp1/ultra96v2-platform/export/ultra96v2-platform/sw/ultra96v2-platform/linux_domain/rootfs/petalinux-image-minimal-ultra96v2ros2-ultra96v2-zynqmp.ext4")
set(KERNEL_IMG "/home/akira/work/ultra96v2/boot/Image")


add_subdirectory(platform)

message(STATUS "PLATFORM_PATH:${PLATFORM_PATH}")

add_subdirectory(host)
add_subdirectory(hw_kernel)
add_subdirectory(hw_link)
