include_guard()

# Usage: add_unit(target_name [isLIB]
# [SRCS         <file.cpp/file.cc>]
# [LIBS         <libs/other_targets>]
# [INCLUDE_DIRS <include_dirs>]
# [LINK_DIRS    <link_dirs>]
# [DEFS         <defs>]
# [FEATS        <features>]
# [ALIAS        alias]
# )
# If SRC is not specfied, ${target_name}.cc/cpp is used as the default source.
function(add_unit name)
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords> <multi_value_keywords> args...)
  set(options isLIB INTERFACE APPEND_SOURCE EXCLUDE_FROM_ALL)
  set(oneValueArgs "ALIAS")
  set(multiValueArgs "GLOB_SRCS;SRCS;LIBS;INCLUDE_DIRS;LINK_DIRS;DEFS;FEATS;OPTIONS")
  cmake_parse_arguments(
    arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )

  if (arg_APPEND_SOURCE AND NOT TARGET ${name})
    message(FATAL_ERROR "Append Source to Target(${name}) failed, since ${name} isn't created.")
  endif()
  if (NOT arg_APPEND_SOURCE AND TARGET ${name})
    message(FATAL_ERROR "Target: ${name} has been created.")
  endif()

  # auto detect source base on target_name.
  if(NOT arg_INTERFACE AND NOT DEFINED arg_SRCS AND NOT DEFINED arg_GLOB_SRCS)
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
    ASSERT_NOT_EMPTY(arg_SRCS)
  endif()

  # create target.
  if (arg_APPEND_SOURCE)
    target_sources(${name} PRIVATE ${arg_SRCS})
  elseif (arg_isLIB)
    if (arg_EXCLUDE_FROM_ALL)
      add_library(${name} EXCLUDE_FROM_ALL ${arg_SRCS})
    else()
      add_library(${name} ${arg_SRCS})
    endif()
  elseif (arg_INTERFACE)
    add_library(${name} INTERFACE ${arg_SRCS})
  else()
    if (arg_EXCLUDE_FROM_ALL)
      add_executable(${name} EXCLUDE_FROM_ALL ${arg_SRCS})
    else()
      add_executable(${name} ${arg_SRCS})
    endif()
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
        if (arg_INTERFACE)
          list(PREPEND ${args} INTERFACE)
        elseif(arg_isLIB)
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
    add_library(${arg_ALIAS} ALIAS ${name})
  endif()
endfunction()
