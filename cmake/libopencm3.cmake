set(LIBOPENCM3_DIR ${CMAKE_SOURCE_DIR}/third-party/libopencm3)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS ${LIBOPENCM3_DIR}/Makefile)
    message(FATAL_ERROR "libopencm3 submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

set(LIBOPENCM3_INC_DIR ${LIBOPENCM3_DIR}/include)

add_custom_target(
        libopencm3
        COMMAND make -j4 PREFIX=${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX} TARGETS=stm32/f1 all
        WORKING_DIRECTORY ${LIBOPENCM3_DIR}
)

link_directories(${LIBOPENCM3_DIR}/lib)

include_directories(${LIBOPENCM3_INC_DIR})

set(LIBOPENCM3_LIB opencm3_stm32f1)

set(LINKER_FILE "${CMAKE_SOURCE_DIR}/config/stm32f103c8t6.ld")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --static -nostartfiles ")

set(LIBOPENCM3_LINKER_FLAGS " --static -nostartfiles ")

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} ${LIBOPENCM3_LIB})

set(EXTERNAL_DEPENDENCIES ${EXTERNAL_DEPENDENCIES} libopencm3)

set(EXTERNAL_EXECUTABLES ${EXTERNAL_EXECUTABLES} opencm3.c)
