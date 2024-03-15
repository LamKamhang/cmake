include_guard()

if ((DEFINED LAM_USE_CLANG_TOOLS AND NOT LAM_USE_CLANG_TOOLS) OR
    (DEFINED LAM_USE_CLANG_FORMAT AND NOT LAM_USE_CLANG_FORMAT))
  return()
endif()
message(STATUS "[cmake/clang-format]: Enable clang-tidy.")

find_program(CLANG_FORMAT clang-format)

if(CLANG_FORMAT)
  message(STATUS "clang-format find: ${CLANG_FORMAT}")
else()
  message(FATAL_ERROR "clang-format not found! please set {CLANG_FORMAT_ROOT} correctly!")
endif()

# Usage:
# code_format(
#  source_paths...
#  [PATTERNS "*.cc;*.[ch]pp;*.hh;*.[ch]xx;*.[ch]"]
# )
function(code_format)
  cmake_parse_arguments(ARGS "" "" "PATTERNS" "${ARGV}")
  if (NOT DEFINED ARGS_PATTERNS)
    set(ARGS_PATTERNS "*.cc;*.hh;*.[ch]pp;*.[ch]xx;*.[ch]")
  endif()

  foreach(path ${ARGS_UNPARSED_ARGUMENTS})
    foreach(ptn ${ARGS_PATTERNS})
      list(APPEND source_pattern ${path}/${ptn})
    endforeach()
  endforeach()
  file(GLOB_RECURSE FORMAT_SOURCES ${source_pattern})
  add_custom_target(code-format-inplace
    COMMAND ${CLANG_FORMAT} -i ${FORMAT_SOURCES}
  )
  add_custom_target(code-format
    COMMAND ${CLANG_FORMAT} --dry-run ${FORMAT_SOURCES}
  )
endfunction()
