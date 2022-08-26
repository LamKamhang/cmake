# Usage: add_unit(target_name [isLIB] [INTERFACE]
#                 [SRCS         <file.cpp/file.cc>]
#                 [LIBS         <libs/other_targets>]
#                 [INCLUDE_PATH <include_paths>]
#                 [LINK_PATH    <link_paths>]
#                 [DEFS         <defs>]
#                 [FEATS        <features>]
#                 )
# If SRC is not specfied, ${target_name}.cc is used as the default source.
function(add_unit name)
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords> <multi_value_keywords> args...)
  set(options isLIB INTERFACE)
  set(multiValueArgs "SRCS;LIBS;INCLUDE_PATH;LINK_PATH;DEFS;FEATS")
  cmake_parse_arguments(
    arg "${options}" "" "${multiValueArgs}" ${ARGN}
    )

  if (NOT DEFINED arg_SRCS)
    set(arg_SRCS ${name}.cc)
  endif()

  if (arg_INTERFACE)
    set(scope INTERFACE)
  else()
    unset(scope)
  endif()

  if (arg_isLIB)
    add_library(${name} ${scope} ${arg_SRCS})
  else()
    add_executable(${name} ${scope} ${arg_SRCS})
  endif()

  if (DEFINED arg_LIBS)
    target_link_libraries(${name} ${scope} ${arg_LIBS})
  endif()

  if (DEFINED arg_INCLUDE_PATH)
    target_include_directories(${name} ${scope} ${arg_INCLUDE_PATH})
  endif()

  if (DEFINED arg_LINK_PATH)
    target_link_directories(${name} ${scope} ${arg_LINK_PATH})
  endif()

  if (DEFINED arg_DEFS)
    target_compile_definitions(${name} ${scope} ${arg_DEFS})
  endif()

  if (DEFINED arg_FEATS)
    target_compile_features(${name} ${scope} ${arg_FEATS})
  endif()
endfunction()
