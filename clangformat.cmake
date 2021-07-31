find_program(CLANG_FORMAT "clang-format")
if (CLANG_FORMAT)
  message(STATUS "clang-format find: ${CLANG_FORMAT}")
else()
  message(FATAL_ERROR "clang-format not found! please set {CLANG_FORMAT_ROOT} correctly!")
endif()

function(code_format)
  file(GLOB_RECURSE FORMAT_SOURCES ${ARGN})
  message(STATUS "code to be formatted: ${FORMAT_SOURCES}")
  add_custom_target(code-format-inplace
    COMMAND clang-format -i ${FORMAT_SOURCES}
    )
  add_custom_target(code-format
    COMMAND clang-format --dry-run ${FORMAT_SOURCES}
    )
endfunction()
