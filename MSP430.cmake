message("Loading MSP430 Toolchain File...")

set(CMAKE_SYSTEM_NAME Generic)
set(TOOLS_ROOT $ENV{HOME}/ti/msp430-gcc)

set(CMAKE_C_COMPILER ${TOOLS_ROOT}/bin/msp430-elf-gcc CACHE STRING "MSP C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLS_ROOT}/bin/msp430-elf-g++ CACHE STRING "MSP C++ Compiler")

set(MSP430_COMPILER_FLAGS "-mtiny-printf" CACHE STRING "MSP Compiler Flags")
set(MSP430_LINKER_FLAGS "-mtiny-printf -Wl,--gc-sections,-Map,\"${PROJECT_NAME}.map\"" CACHE STRING "MSP Linker Flags")

function(msp430_add_executable EXECUTABLE)
	if(NOT MSP430_DEVICE_NAME)
		message(FATAL_ERROR "Variable named MSP430_DEVICE_NAME not defined - this needs to contain the name of the MSP as shown in MSP compiler install_dir/include/devices.csv!")
	endif()

	# compile and link elf file
	add_executable(${EXECUTABLE} ${ARGN})
	set_target_properties(${EXECUTABLE} PROPERTIES 
		COMPILE_FLAGS "-mmcu=${MSP430_DEVICE_NAME} ${MSP430_COMPILER_FLAGS}"
		LINK_FLAGS "-mmcu=${MSP430_DEVICE_NAME} ${MSP430_LINKER_FLAGS}")
    target_include_directories(${EXECUTABLE} PRIVATE
        ${TOOLS_ROOT}/include
    )
    target_link_directories(${EXECUTABLE} PRIVATE
        ${TOOLS_ROOT}/include
    )
endfunction(msp430_add_executable)
