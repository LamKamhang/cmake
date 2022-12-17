cmake_minimum_required(VERSION 3.12)

include_guard()

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
use_cmake_core_module(package)
use_cmake_core_module(target-helper)

# register paths
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/find_modules) # for find_package
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/packages) # for include
