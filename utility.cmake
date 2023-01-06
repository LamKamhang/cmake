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
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/tools) # for include

set(CMAKE_UTILITY_PATCH_DIR ${CMAKE_CURRENT_LIST_DIR}/patches)

# for register packages.
macro(declare_pkg_deps)
  foreach(dep ${ARGV})
    # split dep into name[@version]
    if (${dep} MATCHES "^([^@ ]+)(@[^@ ]*)?$")
      if (CMAKE_MATCH_2)
        if (NOT ${CMAKE_MATCH_2} STREQUAL "@default")
          string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 ${CMAKE_MATCH_1}_VERSION)
          message(DEBUG "${CMAKE_MATCH_1} use ${${CMAKE_MATCH_1}_VERSION}")
        else()
          message(DEBUG "${CMAKE_MATCH_1} use default")
        endif()
      endif()
      include(pkg_${CMAKE_MATCH_1})
    else()
      ERROR_MSG("Unvalid dep Format(^([^@ ]+)(@[^@ ]*)?$): ${dep}")
    endif()
  endforeach()
endmacro()
