cmake_minimum_required(VERSION 3.1)

project(ultra96v2_platform
    VERSION 1.0
    LANGUAGES NONE)

set( XSCT "$ENV{XILINX_VITIS}/bin/xsct")

add_custom_command(
    OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_gen.timestamp
    COMMAND ${XSCT} ${CMAKE_CURRENT_SOURCE_DIR}/platform.tcl
    COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_gen.timestamp
)

add_custom_target( ultra96v2_platform ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_gen.timestamp
)

set( PLATFORM_PATH "${CMAKE_CURRENT_BINARY_DIR}/ultra96v2_platform/export/ultra96v2_platform/ultra96v2_platform.xpfm" PARENT_SCOPE)

