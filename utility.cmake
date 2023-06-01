cmake_minimum_required(VERSION 3.12)

include_guard()

# set policy
cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

macro(use_cmake_core_module module)
  string(REPLACE "-" "_" MODULE ${module})
  string(TOUPPER ${MODULE} MODULE)
  option(CMAKE_UTILITIES_USE_${MODULE} "Use cmake-core-${module}" ON)

  if(CMAKE_UTILITIES_USE_${MODULE})
    message(STATUS "[cmake-utility] Use cmake-core-${module}")
    include(${CMAKE_CURRENT_LIST_DIR}/core/cmake-core-${module}.cmake)
  endif()

  unset(MODULE)
endmacro()

# register modules
use_cmake_core_module(fs)
# deprecated package-module and use CPM.cmake instead.
#use_cmake_core_module(package)
use_cmake_core_module(package-cpm)
use_cmake_core_module(target-helper)

# register paths
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/find_modules) # for find_package
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/packages) # for include
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/tools) # for include

set(CMAKE_UTILITY_PATCH_DIR ${CMAKE_CURRENT_LIST_DIR}/patches)
