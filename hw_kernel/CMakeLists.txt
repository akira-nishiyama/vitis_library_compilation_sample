cmake_minimum_required(VERSION 3.1)

project(hw_kernel
    VERSION 1.0
    LANGUAGES NONE)

set(VPP "$ENV{XILINX_VITIS}/bin/v++")

set(SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/vadd.cpp")

add_custom_command(
    OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/vadd_${BUILD_TARGET}.xo
    COMMAND ${VPP} --target ${BUILD_TARGET} --compile -I${CMAKE_CURRENT_SOURCE_DIR}
            -k vadd --debug
            --save-temps --temp_dir ${CMAKE_CURRENT_BINARY_DIR}/build
            --report_dir ${CMAKE_CURRENT_BINARY_DIR}/reports --log_dir ${CMAKE_CURRENT_BINARY_DIR}/logs
            --platform ${PLATFORM_PATH} -o${CMAKE_CURRENT_BINARY_DIR}/vadd_${BUILD_TARGET}.xo ${SRC_FILES}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/vadd.cpp ultra96v2_platform
)

add_custom_target( hw_kernel_vadd ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/vadd_${BUILD_TARGET}.xo
)

set(HW_KERNELS "${CMAKE_CURRENT_BINARY_DIR}/vadd_${BUILD_TARGET}.xo;${HW_KERNELS}" PARENT_SCOPE)
set(HW_KERNEL_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/vadd.cpp;${HW_KERNEL_SRCS}" PARENT_SCOPE)
