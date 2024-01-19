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

function(code_format)
  file(GLOB_RECURSE FORMAT_SOURCES ${ARGN})
  add_custom_target(code-format-inplace
    COMMAND ${CLANG_FORMAT} -i ${FORMAT_SOURCES}
  )
  add_custom_target(code-format
    COMMAND ${CLANG_FORMAT} --dry-run ${FORMAT_SOURCES}
  )
endfunction()
