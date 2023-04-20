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
  set(options isLIB INTERFACE)
  set(oneValueArgs "SCOPE;ALIAS")
  set(multiValueArgs "GLOB_SRCS;SRCS;LIBS;INCLUDE_DIRS;LINK_DIRS;DEFS;FEATS;OPTIONS")
  cmake_parse_arguments(
    arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )

  if(arg_INTERFACE)
    set(scope INTERFACE)
  else()
    if(DEFINED arg_SCOPE)
      set(scope ${arg_SCOPE})
    else()
      unset(scope)
    endif()

    if(NOT DEFINED arg_SRCS AND NOT DEFINED arg_GLOB_SRCS)
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
  endif()

  if (DEFINED arg_GLOB_SRCS)
    file(GLOB_RECURSE glob_srcs ${arg_GLOB_SRCS})
    list(APPEND arg_SRCS ${glob_srcs})
    ASSERT_NOT_EMPTY(arg_SRCS)
  endif()

  if(arg_isLIB OR arg_INTERFACE)
    add_library(${name} ${scope} ${arg_SRCS})
  else()
    add_executable(${name} ${scope} ${arg_SRCS})
  endif()

  if(DEFINED arg_LIBS)
    target_link_libraries(${name} ${scope} ${arg_LIBS})
  endif()

  if(DEFINED arg_INCLUDE_DIRS)
    target_include_directories(${name} ${scope} ${arg_INCLUDE_DIRS})
  endif()

  if(DEFINED arg_LINK_DIRS)
    target_link_directories(${name} ${scope} ${arg_LINK_DIRS})
  endif()

  if(DEFINED arg_DEFS)
    target_compile_definitions(${name} ${scope} ${arg_DEFS})
  endif()

  if(DEFINED arg_FEATS)
    target_compile_features(${name} ${scope} ${arg_FEATS})
  endif()

  if(DEFINED arg_OPTIONS)
    target_compile_options(${name} ${scope} ${arg_OPTIONS})
  endif()

  if (DEFINED arg_ALIAS)
    add_library(${arg_ALIAS} ALIAS ${name})
  endif()
endfunction()
