find_program(CLANG_TIDY clang-tidy)
if (CLANG_TIDY)
  message(STATUS "clang-tidy find: ${CLANG_TIDY}")
else()
  message(FATAL_ERROR "clang-tidy not found! please set {CLANG_TIDY_ROOT} correctly!")
endif()

function(code_tidy)
  file(GLOB_RECURSE TIDY_SOURCES ${ARGN})
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
