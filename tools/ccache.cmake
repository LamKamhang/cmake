include_guard()

# Enable ccache/sccache.
find_program(CCACHE_FOUND ccache)
find_program(SCCACHE_FOUND sccache)

if (LAM_USE_SCCACHE AND SCCACHE_FOUND)
  message(STATUS "[cmake/tools]: Enable sccache...")
  set(CMAKE_CXX_COMPILER_LAUNCHER sccache)
  set(CMAKE_C_COMPILER_LAUNCHER sccache)
elseif(LAM_USE_CCACHE AND CCACHE_FOUND)
  message(STATUS "[cmake/tools]: Enable ccache...")
  set(CMAKE_CXX_COMPILER_LAUNCHER ccache)
  set(CMAKE_CXX_COMPILER_LAUNCHER ccache)
endif()
