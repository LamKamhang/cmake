include_guard()

cmake_minimum_required(VERSION 3.12)

# set policy.
cmake_policy(SET CMP0077 NEW)

# Point to the current list dir.
set(_CMAKE_UTILITY_BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_CMAKE_UTILITY_PACKAGES_DIR ${CMAKE_CURRENT_LIST_DIR}/packages)

macro(use_cmake_core_module module)
  string(TOUPPER ${module} MODULE)
  option(CMAKE_UTILITY_USE_${MODULE} "Use cmake-core-${module}" ON)

  if (CMAKE_UTILITY_USE_${MODULE})
    message(STATUS "[cmake/utility] Use cmake-core-${module}")
    include(${_CMAKE_UTILITY_BASE_DIR}/core/${module}.cmake)
  endif()

  unset(MODULE)
endmacro()

macro(register_cmake_module_path path)
  string(TOUPPER ${path} PATH)
  option(CMAKE_UTILITY_USE_${PATH} "add cmake module path: ${_CMAKE_UTILITY_BASE_DIR}/${path}" ON)

  if (CMAKE_UTILITY_USE_${PATH})
    message(STATUS "[cmake/utility] Add cmake module path: ${_CMAKE_UTILITY_BASE_DIR}/${path}")
    list(PREPEND CMAKE_MODULE_PATH ${_CMAKE_UTILITY_BASE_DIR}/${path})
  endif()
endmacro()

# register modules
use_cmake_core_module(fs)
use_cmake_core_module(package_cpm)
use_cmake_core_module(target_helper)

# register path.
register_cmake_module_path(find_modules)
register_cmake_module_path(tools)
