# :< You Shall Not Pass!
if (0)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Werror")
endif ()

if (SYSTEM.Darwin)
  # set(compiler_flags "${compiler_flags} -nostdinc++")
  if (NOT DOBBY_DEBUG)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-x -Wl,-S")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_log_internal_impl -Wl,-exported_symbol,_log_set_level")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_CodePatch")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_DobbyGetVersion -Wl,-exported_symbol,_DobbyGetInterceptorInfo -Wl,-exported_symbol,_DobbyHook -Wl,-exported_symbol,_DobbyInstrument -Wl,-exported_symbol,_DobbyDestroy")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_DobbyGlobalOffsetTableReplace")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_DobbySymbolResolver")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_common_closure_bridge_handler")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-exported_symbol,_dobby_enable_near_branch_trampoline -Wl,-exported_symbol,_dobby_disable_near_branch_trampoline")
  endif ()
elseif (SYSTEM.Android)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fomit-frame-pointer")
  if (NOT DOBBY_DEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffunction-sections -fdata-sections")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--gc-sections -Wl,--exclude-libs,ALL")
  endif ()
elseif (SYSTEM.Linux)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
elseif (SYSTEM.Windows)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_SECURE_NO_DEPRECATE)
  if (NOT DOBBY_DEBUG)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /export:log_internal_impl")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /export:DobbyHook /export:DobbyInstrument /export:DobbySymbolResolver")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /export:dobby_enable_near_branch_trampoline /export:dobby_disable_near_branch_trampoline")
  endif ()
endif ()

if (COMPILER.Clang)
  if (NOT DOBBY_DEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fvisibility=hidden -fvisibility-inlines-hidden")
  endif ()
  if (PROCESSOR.ARM)
    set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -arch armv7 -x assembler-with-cpp")
  elseif (PROCESSOR.AARCH64)
    set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -arch arm64 -x assembler-with-cpp")
  endif ()
endif ()

# sync cxx with c flags
# set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}")

message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "CMAKE_SHARED_LINKER_FLAGS: ${CMAKE_SHARED_LINKER_FLAGS}")
