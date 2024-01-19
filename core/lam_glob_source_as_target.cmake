include_guard()

use_cmake_core_module(lam_add_target)

# Usage:
# lam_glob_source_as_target(pattern)
# [LIST_DIRECTORY  BOOLEAN]
# [LIBS         <libs/other_targets>]
# [INCLUDE_DIRS <include_dirs>]
# [LINK_DIRS    <link_dirs>]
# [DEFS         <defs>]
# [FEATS        <features>]
# [RUNTIME_OUTPUT_DIRECTORY <path>]
function(lam_glob_source_as_target patterns)
  set(options "")
  set(singleValueArgs "LIST_DIRECTORY;RUNTIME_OUTPUT_DIRECTORY")
  set(multiValueArgs "")
  cmake_parse_arguments(ARGS
    "${options}"
    "${singleValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  if(NOT DEFINED ARGS_LIST_DIRECTORY)
    set(ARGS_LIST_DIRECTORY OFF)
  endif()

  foreach(ptn ${patterns})
    file(GLOB current_lam_target_sources
      LIST_DIRECTORIES ${ARGS_LIST_DIRECTORY}
      RELATIVE ${CMAKE_CURRENT_LIST_DIR} # points to where call this function.
      "${ptn}"
    )
    list(APPEND lam_target_sources ${current_lam_target_sources})
  endforeach()

  foreach(single_file_target ${lam_target_sources})
    # TODO: only support one source file per target.
    # and the source file only support *.cpp.
    string(REGEX REPLACE "\\.cpp$" "" target_name ${single_file_target})
    if (NOT TARGET ${target_name})
      message(STATUS "[cmake/glob-targets]: ${single_file_target} => ${target_name}")
      lam_add_target(${target_name} SRCS ${single_file_target} ${ARGS_UNPARSED_ARGUMENTS})
      if (DEFINED ARGS_RUNTIME_OUTPUT_DIRECTORY)
        set_target_properties(${target_name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${ARGS_RUNTIME_OUTPUT_DIRECTORY})
      endif()
    else()
      message(STATUS "[cmake/glob-targets]: ${target_name} has been defined, skip it.")
    endif()
  endforeach()
endfunction()

macro(lam_glob_benchmark_source_as_target patterns)
  lam_glob_source_as_target(${ARGV}
    LIBS benchmark::benchmark_main
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/benchmark"
  )
endmacro()

macro(lam_glob_app_source_as_target patterns)
  lam_glob_source_as_target(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/apps"
  )
endmacro()

macro(lam_glob_example_source_as_target patterns)
  lam_glob_source_as_target(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/examples"
  )
endmacro()

macro(lam_glob_test_source_as_target patterns)
  lam_glob_source_as_target(${ARGV}
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  )
endmacro()
