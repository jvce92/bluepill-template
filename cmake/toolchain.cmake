set(TOOLCHAIN_PREFIX arm-none-eabi-)
set(UTIL_SEARCH_CMD which)
execute_process(
        COMMAND ${UTIL_SEARCH_CMD} ${TOOLCHAIN_PREFIX}gcc
        OUTPUT_VARIABLE BINUTILS_PATH
        OUTPUT_STRIP_TRAILING_WHITESPACE
)
get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)

set(CMAKE_AR               ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}gcc-ar)
set(CMAKE_RANLIB           ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}gcc-ranlib)
set(CMAKE_LD               ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}ld)
set(CMAKE_C_COMPILER       ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER     ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}g++)
set(CMAKE_ASM_COMPILER     ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}as)
set(CMAKE_OBJCOPY     	   ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy command")
set(CMAKE_OBJDUMP     	   ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objdump CACHE INTERNAL "objdump command")
set(CMAKE_GDB              ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}gdb)
set(CMAKE_SIZE             ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}size)

set(CMAKE_C_ARCHIVE_CREATE "${CMAKE_AR} qc <TARGET> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET>")

set(COMPILER_OPTIONS "-mthumb -mcpu=cortex-m3 -mlittle-endian -mthumb-interwork ")

set(CMAKE_C_FLAGS "${COMPILER_OPTIONS} -lm -lc -lnosys --specs=nosys.specs " CACHE INTERNAL "c compiler flags")
set(CMAKE_CXX_FLAGS "${COMPILER_OPTIONS} -lm -lc -lnosys --specs=nosys.specs " CACHE INTERNAL "cxx compiler flags")
set(CMAKE_ASM_FLAGS "${COMPILER_OPTIONS}" CACHE INTERNAL "asm compiler flags")

set(CMAKE_EXE_LINKER_FLAGS "${COMPILER_OPTIONS} -Wl,-Map=linker.map -Wl,-cref -Wl,--gc-sections" CACHE INTERNAL "exe link flags")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment,
# search programs in the host environment
#
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <FLAGS> -o <OBJECT> <SOURCE>")