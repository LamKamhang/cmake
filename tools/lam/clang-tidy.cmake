include_guard()

if ((DEFINED LAM_USE_CLANG_TOOLS AND NOT LAM_USE_CLANG_TOOLS) OR
    (DEFINED LAM_USE_CLANG_TIDY AND NOT LAM_USE_CLANG_TIDY))
  return()
endif()
message(STATUS "[cmake/clang-tidy]: Enable clang-tidy.")

find_program(CLANG_TIDY clang-tidy)

if(CLANG_TIDY)
  message(STATUS "clang-tidy find: ${CLANG_TIDY}")
else()
  message(FATAL_ERROR "clang-tidy not found! please set {CLANG_TIDY_ROOT} correctly!")
endif()

# Usage:
# code_tidy(
#  source_paths...
#  [PATTERNS "*.cc;*.[ch]pp;*.hh;*.[ch]xx;*.[ch]"]
# )
function(code_tidy)
  cmake_parse_arguments(ARGS "" "" "PATTERNS" "${ARGV}")
  if (NOT DEFINED ARGS_PATTERNS)
    set(ARGS_PATTERNS "*.cc;*.hh;*.[ch]pp;*.[ch]xx;*.[ch]")
  endif()

  foreach(path ${ARGS_UNPARSED_ARGUMENTS})
    foreach(ptn ${ARGS_PATTERNS})
      list(APPEND source_pattern ${path}/${ptn})
    endforeach()
  endforeach()

  file(GLOB_RECURSE TIDY_SOURCES ${source_pattern})
  add_custom_target(code-tidy-inplace
    COMMAND ${CLANG_TIDY}
    --export-fixes=${CMAKE_BINARY_DIR}/clang-tidy-fix.yml
    -p=${CMAKE_BINARY_DIR}
    --fix
    ${TIDY_SOURCES}
  )
  add_custom_target(code-tidy
    COMMAND ${CLANG_TIDY}
    --export-fixes=${CMAKE_BINARY_DIR}/clang-tidy-fix.yml
    -p=${CMAKE_BINARY_DIR}
    ${TIDY_SOURCES}
  )
endfunction()
