include_guard()

use_cmake_core_module(lam_assert)

# Usage:
# lam_add_target(target_name [isLIB|SHARED|STATIC|isINTERFACE]
# [SRCS         <file.cpp/file.cc>]
# [LIBS         <libs/other_targets>]
# [INCLUDE_DIRS <include_dirs>]
# [LINK_DIRS    <link_dirs>]
# [DEFS         <defs>]
# [FEATS        <features>]
# [ALIAS        alias]
# )
# If SRC is not specfied, ${target_name}.cc/cpp is used as the default source.
function(lam_add_target name)
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords> <multi_value_keywords> args...)
  set(options isLIB isINTERFACE APPEND_SOURCE EXCLUDE_FROM_ALL SHARED STATIC)
  set(multiValueArgs "GLOB_SRCS;SRCS;LIBS;INCLUDE_DIRS;LINK_DIRS;DEFS;FEATS;OPTIONS;ALIAS")
  cmake_parse_arguments(
    arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )

  # Assert some conditions.
  if (arg_APPEND_SOURCE)
    lam_debug("Check Target Defined for APPEND_SOURCE.")
    lam_assert_target_defined(${name})
    lam_assert_falsy(
      arg_isLIB arg_isINTERFACE arg_EXCLUDE_FROM_ALL arg_SHARED arg_STATIC
    )
  else()
    lam_debug("Check target not defined for no APPEND_SOURCE")
    lam_assert_target_not_defined(${name})
  endif()
  if (arg_EXCLUDE_FROM_ALL)
    lam_assert_falsy(arg_isINTERFACE arg_APPEND_SOURCE)
  endif()
  if (arg_isINTERFACE)
    lam_assert_falsy(arg_STATIC arg_isLIB arg_SHARED arg_APPEND_SOURCE)
  endif()
  if (arg_STATIC)
    lam_assert_falsy(arg_isINTERFACE arg_SHARED arg_APPEND_SOURCE)
  endif()
  if (arg_SHARED)
    lam_assert_falsy(arg_isINTERFACE arg_STATIC arg_APPEND_SOURCE)
  endif()

  # auto detect source base on target_name.
  if(NOT arg_isINTERFACE AND NOT DEFINED arg_SRCS AND NOT DEFINED arg_GLOB_SRCS)
    foreach(src ${arg_UNPARSED_ARGUMENTS})
      if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/${src})
        list(APPEND arg_SRCS ${src})
      endif()
    endforeach()
    if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${name}.cc)
      list(APPEND arg_SRCS ${name}.cc)
    elseif(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${name}.cpp)
      list(APPEND arg_SRCS ${name}.cpp)
    elseif(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${name}.cxx)
      list(APPEND arg_SRCS ${name}.cxx)
    endif()
    list(LENGTH arg_SRCS NUM)
    if (NUM EQUAL 0)
      message(FATAL_ERROR "Cannot determine which source file for: [${name}].")
    endif()
  endif()

  # glob source.
  if (DEFINED arg_GLOB_SRCS)
    file(GLOB_RECURSE glob_srcs ${arg_GLOB_SRCS})
    list(APPEND arg_SRCS ${glob_srcs})
    lam_assert_not_empty_var(arg_SRCS)
  endif()

  # prepare arg_SRCS.
  if (arg_EXCLUDE_FROM_ALL)
    list(PREPEND arg_SRCS EXCLUDE_FROM_ALL)
  endif()

  # create target.
  if (arg_APPEND_SOURCE)
    target_sources(${name} PRIVATE ${arg_SRCS})
  elseif (arg_STATIC)
    add_library(${name} STATIC ${arg_SRCS})
  elseif (arg_SHARED)
    add_library(${name} SHARED ${arg_SRCS})
  elseif (arg_isINTERFACE)
    add_library(${name} INTERFACE ${arg_SRCS})
  elseif (arg_isLIB)
    add_library(${name} ${arg_SRCS})
  else ()
    add_executable(${name} ${arg_SRCS})
  endif()

  # refine args.
  set(command_args
    arg_LIBS
    arg_LINK_DIRS
    arg_INCLUDE_DIRS
    arg_DEFS
    arg_FEATS
    arg_OPTIONS
  )
  foreach(args IN LISTS command_args)
    if (DEFINED ${args})
      list(GET ${args} 0 FIRST_ARG)
      if (${FIRST_ARG} STREQUAL PUBLIC OR
          ${FIRST_ARG} STREQUAL PRIVATE OR
          ${FIRST_ARG} STREQUAL INTERFACE)
        # continue.
      else()
        if (arg_isINTERFACE)
          list(PREPEND ${args} INTERFACE)
        elseif(arg_isLIB OR arg_STATIC OR arg_SHARED)
          list(PREPEND ${args} PUBLIC)
        else()
          list(PREPEND ${args} PRIVATE)
        endif()
      endif()
      unset(FIRST_ARG)
    endif()
  endforeach()

  if (DEFINED arg_LIBS)
    target_link_libraries(${name} ${arg_LIBS})
  endif()
  if (DEFINED arg_LINK_DIRS)
    target_link_directories(${name} ${arg_LINK_DIRS})
  endif()
  if (DEFINED arg_INCLUDE_DIRS)
    target_include_directories(${name} ${arg_INCLUDE_DIRS})
  endif()
  if (DEFINED arg_DEFS)
    target_compile_definitions(${name} ${arg_DEFS})
  endif()
  if (DEFINED arg_FEATS)
    target_compile_features(${name} ${arg_FEATS})
  endif()
  if (DEFINED arg_OPTIONS)
    target_compile_options(${name} ${arg_OPTIONS})
  endif()

  if (DEFINED arg_ALIAS)
    # enable multi-alias.
    foreach(_ALIAS_NAME ${arg_ALIAS})
      add_library(${_ALIAS_NAME} ALIAS ${name})
    endforeach()
  endif()
endfunction()

function(lam_add_interface name)
  lam_add_target(${ARGV} isINTERFACE)
endfunction()

function(lam_add_library name)
  lam_add_target(${ARGV} isLIB)
endfunction()

function(lam_add_example name)
  lam_add_target(${ARGV})
  set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/examples")
endfunction()

function(lam_add_app name)
  lam_add_target(${ARGV})
  set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/apps")
endfunction()

function(lam_add_test name)
  lam_add_target(${ARGV})
  set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests")
endfunction()

function(lam_add_benchmark name)
  if (NOT TARGET benchmark::benchmark_main)
    lam_use_deps(benchmark)
  endif()
  lam_add_target(${ARGV} LIBS benchmark::benchmark_main)
  set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/benchmark")
endfunction()
