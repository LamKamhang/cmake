include_guard()

use_cmake_core_module(lam_add_target)

# Usage:
# lam_add_targets_from_glob(pattern)
# [LIST_DIRECTORY  BOOLEAN]
# [LIBS         <libs/other_targets>]
# [INCLUDE_DIRS <include_dirs>]
# [LINK_DIRS    <link_dirs>]
# [DEFS         <defs>]
# [FEATS        <features>]
# [RUNTIME_OUTPUT_DIRECTORY <path>]
function(lam_add_targets_from_glob patterns)
  set(options "")
  set(singleValueArgs "RECURSE;RUNTIME_OUTPUT_DIRECTORY")
  set(multiValueArgs "")
  cmake_parse_arguments(ARGS
    "${options}"
    "${singleValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  # ensure ARGS_RECURSE is defined.
  #   set it to FALSE if not defined.
  if (NOT DEFINED ARGS_RECURSE)
    set(ARGS_RECURSE FALSE)
  endif()

  if (ARGS_RECURSE)
    set(GLOB_MODE GLOB_RECURSE)
  else()
    set(GLOB_MODE GLOB)
  endif()

  # glob files w.r.t. patterns
  foreach(ptn ${patterns})
    file(${GLOB_MODE} current_lam_target_sources
      LIST_DIRECTORIES FALSE
      RELATIVE ${CMAKE_CURRENT_LIST_DIR} # points to where call this function.
      "${ptn}"
    )
    list(APPEND lam_target_sources ${current_lam_target_sources})
  endforeach()

  foreach(single_file_target ${lam_target_sources})
    get_filename_component(target_name ${single_file_target} NAME_WE)
    if (NOT TARGET ${target_name})
      message(STATUS "[lam/targets_from_glob]: ${single_file_target} => ${target_name}")
      lam_add_target(${target_name} SRCS ${single_file_target} ${ARGS_UNPARSED_ARGUMENTS})
      if (DEFINED ARGS_RUNTIME_OUTPUT_DIRECTORY)
        set_target_properties(${target_name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${ARGS_RUNTIME_OUTPUT_DIRECTORY})
      endif()
    else()
      message(STATUS "[lam/targets_from_glob]: ${target_name} has been defined, skip it.")
    endif()
  endforeach()
endfunction()

macro(lam_add_benchmarks_from_glob patterns)
  lam_add_targets_from_glob(${ARGV}
    LIBS benchmark::benchmark_main
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/benchmarks"
  )
endmacro()

macro(lam_add_apps_from_glob patterns)
lam_add_targets_from_glob(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/apps"
  )
endmacro()

macro(lam_add_examples_from_glob patterns)
  lam_add_targets_from_glob(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/examples"
  )
endmacro()

macro(lam_add_tests_from_glob patterns)
  lam_add_targets_from_glob(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  )
endmacro()
