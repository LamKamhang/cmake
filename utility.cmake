include_guard()

# use native symlink. Version >= 3.14
cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# set policy.
# https://cmake.org/cmake/help/latest/policy/CMP0077.html
cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

# Point to the current list dir.
set(LAM_CMAKE_UTILITY_BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
set(LAM_CMAKE_UTILITY_CORE_DIR ${LAM_CMAKE_UTILITY_BASE_DIR}/core)
set(LAM_CMAKE_UTILITY_PACKAGES_DIR ${LAM_CMAKE_UTILITY_BASE_DIR}/packages)
set(LAM_CMAKE_UTILITY_TOOLS_DIR ${LAM_CMAKE_UTILITY_BASE_DIR}/tools)

macro(use_cmake_core_module module)
  string(TOUPPER ${module} MODULE__)
  option(CMAKE_UTILITY_USE_${MODULE__} "Use cmake-core-${module}" ON)

  if (CMAKE_UTILITY_USE_${MODULE__})
    message(STATUS "[cmake/utility] Use cmake-core-${module}")
    include(${LAM_CMAKE_UTILITY_CORE_DIR}/${module}.cmake)
  endif()

  unset(MODULE__)
endmacro()

macro(register_cmake_module_path path)
  string(TOUPPER ${path} PATH__)
  option(CMAKE_UTILITY_USE_${PATH__} "add cmake module path: ${LAM_CMAKE_UTILITY_BASE_DIR}/${path}" ON)

  if (CMAKE_UTILITY_USE_${PATH__})
    message(STATUS "[cmake/utility] Add cmake module path: ${LAM_CMAKE_UTILITY_BASE_DIR}/${path}")
    if (NOT EXISTS ${LAM_CMAKE_UTILITY_BASE_DIR}/${path})
      message(WARNING "[cmake/utility] path(${LAM_CMAKE_UTILITY_BASE_DIR}/${path}) not found!")
    else()
      list(PREPEND CMAKE_MODULE_PATH ${LAM_CMAKE_UTILITY_BASE_DIR}/${path})
    endif()
  endif()

  unset(PATH__)
endmacro()

# register modules.
use_cmake_core_module(lam_fs)
use_cmake_core_module(lam_package_cpm)
use_cmake_core_module(lam_add_target)
use_cmake_core_module(lam_add_unittest)
use_cmake_core_module(lam_install)
use_cmake_core_module(lam_utils)
use_cmake_core_module(lam_add_targets_from_glob)
use_cmake_core_module(lam_generate_git_meta)
# register path.
register_cmake_module_path(find_modules)
register_cmake_module_path(tools)
