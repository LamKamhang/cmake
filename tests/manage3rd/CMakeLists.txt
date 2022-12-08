cmake_minimum_required(VERSION 3.12)

project(manage3rd)

# set(UTILITY_CMAKE_FILE ${PROJECT_SOURCE_DIR}/cmake/utility.cmake)
# if (NOT EXISTS ${UTILITY_CMAKE_FILE})
#   message(FATAL_ERROR "please `git submodule update --init` to fetch cmake submodule.")
# else()
#   include(${UTILITY_CMAKE_FILE})
# endif()
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

# add collection target.
add_custom_target(fetch_all3rd)
add_custom_target(build_all3rd)
add_custom_target(install_all3rd)

function(add_package name) # args...
  require_package(${name} DEFER LOCAL_FIRST_OFF ${ARGN})
  foreach(cmd fetch build install)
    if (TARGET ${cmd}_${name})
      add_dependencies(${cmd}_all3rd ${cmd}_${name})
    endif()
  endforeach()
endfunction()

set(EXT_PACKAGE_DOWNLOAD_ONLY ON)
add_package(benchmark "rom:google/benchmark.git#origin/main" GIT_SHALLOW ON)
