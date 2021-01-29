cmake_minimum_required(VERSION 3.1)

project(vecadd_lib_host
    VERSION 1.0
    LANGUAGES C CXX)

#emconfig
set( EMCONFIG_UTIL "$ENV{XILINX_VITIS}/bin/emconfigutil")

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/emconfig.json
    COMMAND ${EMCONFIG_UTIL} --od . --nd 1 --platform ${PLATFORM_PATH}
    DEPENDS ultra96v2_platform
)

add_custom_target( emconfig ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/emconfig.json
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/xrt.ini
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/xrt.ini ${CMAKE_CURRENT_BINARY_DIR}/xrt.ini
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/xrt.ini
)

add_custom_target( xrtini ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/xrt.ini
)

#main
add_library(vecadd SHARED vecadd.cpp)

add_executable(vecadd_test vecadd_test.cpp)

target_link_libraries( vecadd_test PUBLIC
    xilinxopencl
    pthread
    rt
    stdc++
    gmp
    xrt_core
    vecadd
)

#install/export settings

install(TARGETS vecadd
    EXPORT vecadd-export
    LIBRARY DESTINATION lib
    INCLUDES DESTINATION include
    PUBLIC_HEADER DESTINATION include/vecadd
)

install(EXPORT vecadd-export
    FILE vecadd-config.cmake
    DESTINATION share/cmake/vecadd
    EXPORT_LINK_INTERFACE_LIBRARIES
)

export(TARGETS vecadd vecadd_test FILE vecadd-export.cmake
    EXPORT_LINK_INTERFACE_LIBRARIES
)

#export for package
set(EXPORT_TARGETS "${CMAKE_CURRENT_BINARY_DIR}/vecadd_test;${CMAKE_CURRENT_BINARY_DIR}/libvecadd.so;${CMAKE_CURRENT_BINARY_DIR}/xrt.ini" PARENT_SCOPE)

