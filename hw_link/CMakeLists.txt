cmake_minimum_required(VERSION 3.1)

project(binary_container_1.xclbin
    VERSION 1.0
    LANGUAGES NONE)

set(VPP "$ENV{XILINX_VITIS}/bin/v++")
set(VPP_DEBUG_OPT "--debug")

#message("HW_KERNELS:${HW_KERNELS}")

#link
add_custom_command(
    OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/binary_container_1_${BUILD_TARGET}.xclbin
    COMMAND ${VPP} --target ${BUILD_TARGET} --link
            ${VPP_DEBUG_OPT}
            --save-temps --temp_dir ${CMAKE_CURRENT_BINARY_DIR}/build
            --report_dir ${CMAKE_CURRENT_BINARY_DIR}/reports --log_dir ${CMAKE_CURRENT_BINARY_DIR}/logs
            --connectivity.nk vadd:1:vadd_1
            --advanced.param compiler.addOutputTypes="sd_card"
            --remote_ip_cache ${PROJECT_BINARY_DIR}/ip_cache
            --platform ${PLATFORM_PATH} -o${CMAKE_CURRENT_BINARY_DIR}/binary_container_1_${BUILD_TARGET}.xclbin
            ${HW_KERNELS}
    DEPENDS ultra96v2_platform ${HW_KERNELS}
)

add_custom_target( gen_xclbin ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/binary_container_1_${BUILD_TARGET}.xclbin
)

#package

add_custom_target( package_config ALL
)

add_custom_command(
    TARGET package_config PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove  ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "platform=${PLATFORM_PATH}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "temp_dir=package.build" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "target=${BUILD_TARGET}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "save-temps=1" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "debug=1" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "[advanced]" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "param=hw_emu.scDebugLevel=waveform_and_log" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "[package]" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "domain=linux_domain" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "kernel_image=${KERNEL_IMG}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "rootfs=${ROOTFS}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E echo "out_dir=./package_${BUILD_TARGET}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
    COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg.timestamp
)

set(package_sd_files "")
set(prev "")
foreach(var ${EXPORT_TARGETS})
    set(package_sd_files "--package.sd_file ${var} ${package_sd_files}")
    add_custom_command(
        TARGET package_config PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "sd_file=${var}" >> ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg.timestamp
    )
endforeach()

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}/sd_card.img
    COMMAND ${VPP} --target ${BUILD_TARGET} --package
            --config ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}.cfg
            ${CMAKE_CURRENT_BINARY_DIR}/binary_container_1_${BUILD_TARGET}.xclbin
            -o binary_container_2_${BUILD_TARGET}.xclbin
    DEPENDS package_config ${CMAKE_CURRENT_BINARY_DIR}/binary_container_1_${BUILD_TARGET}.xclbin
)

add_custom_target( sd_card_package ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/package_${BUILD_TARGET}/sd_card.img
)

