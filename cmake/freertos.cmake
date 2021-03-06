set(FREERTOS_DIR ${CMAKE_SOURCE_DIR}/third-party/FreeRTOS/FreeRTOS/Source)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${FREERTOS_DIR}")
    message(FATAL_ERROR "FreeRTOS submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

set(
        FREERTOS_INC_DIR
        ${FREERTOS_DIR}/include
        ${FREERTOS_DIR}/portable/GCC/ARM_CM3
)

include_directories(
        ${CMAKE_SOURCE_DIR}/config # That's for including the FreeRTOSConfig.h
        ${FREERTOS_INC_DIR}
)
message(${CMAKE_SOURCE_DIR}/config)

set(
        FREERTOS_LIB_SRC
        ${FREERTOS_DIR}/portable/GCC/ARM_CM3/port.c
        ${FREERTOS_DIR}/portable/MemMang/heap_1.c
        ${FREERTOS_DIR}/portable/MemMang/heap_2.c
        ${FREERTOS_DIR}/portable/MemMang/heap_3.c
        ${FREERTOS_DIR}/portable/MemMang/heap_4.c
        ${FREERTOS_DIR}/portable/MemMang/heap_5.c
        ${FREERTOS_DIR}/croutine.c
        ${FREERTOS_DIR}/event_groups.c
        ${FREERTOS_DIR}/list.c
        ${FREERTOS_DIR}/queue.c
        ${FREERTOS_DIR}/README.md
        ${FREERTOS_DIR}/stream_buffer.c
        ${FREERTOS_DIR}/tasks.c
        ${FREERTOS_DIR}/timers.c
)

set_source_files_properties(
        ${FREERTOS_LIB_SRC}
        PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
        # STM32_DEFINES are defined in the top level CMakeLists.txt
)

add_library(freertos STATIC ${FREERTOS_LIB_SRC})

set_target_properties(freertos PROPERTIES LINKER_LANGUAGE C)

# -flto breaks FreeRTOS, so remove it
string(REPLACE "-flto" "" COMPILER_OPTIMISATION ${COMPILER_OPTIMISATION})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} freertos)
