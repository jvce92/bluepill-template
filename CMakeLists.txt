cmake_minimum_required(VERSION 3.13)
project(bluepill-template LANGUAGES C CXX)

option(USE_LIBOPENCM3 "Use libopencm3 HAL" OFF)
option(USE_FREERTOS "Use FreeRTOS" OFF)

# Set STM32 SoC specific variables
set(
        STM32_DEFINES " \
        -DIVECT_TAB_OFFSET=0x0 \
        -DSTM32F1 \
        -DSTM32F103C8Tx \
        -DSTM32 \
        -DSTM32F10X_MD"
)

if (USE_DBGUART)
    message(STATUS "Using debug UART...")
    set(STM32_DEFINES "${STM32_DEFINES} -DUSE_DBGUART")
endif()

# set compiler optimisations
set(COMPILER_OPTIMISATION "-O3")

# libopencm3
if (USE_LIBOPENCM3)
    include(cmake/libopencm3.cmake)
endif()

# FreeRTOS Library
if (USE_FREERTOS)
    include(cmake/freertos.cmake)
endif()

# enable asm for stm startup.s file
enable_language(ASM)
# Custom STM32 options for assembler and gcc
set(STM32_ASM_OPTIONS "-march=armv7-m -mcpu=cortex-m3 -mthumb -mlittle-endian -mthumb-interwork")
set(STM32_COMPILER_OPTIONS "${STM32_ASM_OPTIONS} \
                        -ffunction-sections \
                        -fdata-sections \
                        -mfloat-abi=soft \
                        -fmessage-length=0 \
                        -Wall -Werror \
                        -Wl,-Map=output.map -Wl,--gc-sections \
                        -lm -lc")

set(STM32_CXX_COMPILER_OPTIONS "${STM32_COMPILER_OPTIONS} \
                        -fno-rtti \
                        -fno-exceptions \
                        -fno-builtin \
                        -std=gnu++11 \
                        ")
# Set project options
SET(CMAKE_C_FLAGS "${STM32_COMPILER_OPTIONS} ${COMPILER_OPTIMISATION} -std=c11" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "${STM32_CXX_COMPILER_OPTIONS} ${COMPILER_OPTIMISATION} -std=c++11 " CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "${STM32_ASM_OPTIONS}" CACHE INTERNAL "asm compiler flags")
# -mthumb -mcpu=cortex-m3 -mfix-cortex-m3-ldrd   -Wl,-Map=linker.map -Wl,-cref  -Wl,--gc-sections
set(EXTRA_LINKER_FLAGS "-lm -lc --specs=nano.specs")
if (USE_SEMIHOSTING)
    set(EXTRA_LINKER_FLAGS "${EXTRA_LINKER_FLAGS} --specs=nosys.specs --specs=rdimon.specs -lrdimon")
endif()
SET(CMAKE_EXE_LINKER_FLAGS "${STM32_COMPILER_OPTIONS} ${LIBOPENCM3_LINKER_FLAGS} -Wl,-Map=linker.map -Wl,-cref " CACHE INTERNAL "exe link flags")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EXTRA_LINKER_FLAGS} -T${LINKER_FILE}")

message(STATUS "System Processor      : ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS
        "BUILD FLAGS:\n"
        "   STM32_DEFINES   : ${STM32_DEFINES}\n"
        "   c flags         : ${CMAKE_C_FLAGS}\n"
        "   c++ flags       : ${CMAKE_CXX_FLAGS}\n"
        "   asm flags       : ${CMAKE_ASM_FLAGS}\n"
        "   ld flags        : ${CMAKE_EXE_LINKER_FLAGS}\n"
        "   optimizations   : ${COMPILER_OPTIMISATION}\n"
        "   FreeRTOS        : ${FREERTOS_INC_DIR}\n"
        "   libopencm3      : ${LIBOPENCM3_INC_DIR}\n"
        )

# add the source code directory
add_subdirectory(src)