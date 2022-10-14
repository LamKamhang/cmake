# Usage: add_unit(target_name [isLIB]
#                 [SRCS         <file.cpp/file.cc>]
#                 [LIBS         <libs/other_targets>]
#                 [INCLUDE_DIRS <include_dirs>]
#                 [LINK_DIRS    <link_dirs>]
#                 [DEFS         <defs>]
#                 [FEATS        <features>]
#                 )
# If SRC is not specfied, ${target_name}.cc is used as the default source.
function(add_unit name)
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords> <multi_value_keywords> args...)
  set(options isLIB INTERFACE)
  set(oneValueArgs "SCOPE")
  set(multiValueArgs "SRCS;LIBS;INCLUDE_DIRS;LINK_DIRS;DEFS;FEATS")
  cmake_parse_arguments(
    arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

  if (arg_INTERFACE)
    set(scope INTERFACE)
  else()
    if (DEFINED arg_SCOPE)
      set(scope ${arg_SCOPE})
    else()
      unset(scope)
    endif()
    if (NOT DEFINED arg_SRCS)
      set(arg_SRCS ${name}.cc)
    endif()
  endif()

  if (arg_isLIB OR arg_INTERFACE)
    add_library(${name} ${scope} ${arg_SRCS})
  else()
    add_executable(${name} ${scope} ${arg_SRCS})
  endif()

  if (DEFINED arg_LIBS)
    target_link_libraries(${name} ${scope} ${arg_LIBS})
  endif()

  if (DEFINED arg_INCLUDE_DIRS)
    target_include_directories(${name} ${scope} ${arg_INCLUDE_DIRS})
  endif()

  if (DEFINED arg_LINK_DIRS)
    target_link_directories(${name} ${scope} ${arg_LINK_DIRS})
  endif()

  if (DEFINED arg_DEFS)
    target_compile_definitions(${name} ${scope} ${arg_DEFS})
  endif()

  if (DEFINED arg_FEATS)
    target_compile_features(${name} ${scope} ${arg_FEATS})
  endif()
endfunction()
