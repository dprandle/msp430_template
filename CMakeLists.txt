cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/MSP430.cmake)

project(TemplateProj)

set(VERSION "1.0.0")
set(REQUIRED_EXT ".elf")
set(MSP430_DEVICE_NAME "msp430fr2311")

set(TARGET_NAME "${PROJECT_NAME}-v${VERSION}${REQUIRED_EXT}")
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)

# Set the src files for the project
file(GLOB SRC_FILES
  "${SRC_DIR}/*.cpp"
  "${SRC_DIR}/*.c"
  )

msp430_add_executable(${TARGET_NAME} ${SRC_FILES})
target_link_libraries(${TARGET_NAME} c gcc)