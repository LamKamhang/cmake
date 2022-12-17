find_program(CPPCHECK "cppcheck")

if(CPPCHECK)
  message(STATUS "cppcheck find: ${CPPCHECK}")
else()
  message(FATAL_ERROR "cppcheck not found! please set {CPPCHECK_ROOT} correctly!")
endif()

function(cppcheck_all)
  add_custom_target(cppcheck
    COMMAND ${CPPCHECK} --project=${CMAKE_BINARY_DIR}/compile_commands.json
    --enable=all
    --error-exitcode=1
    --inline-suppr
    --suppress=missingIncludeSystem
    --suppress=preprocessorErrorDirective
    ${ARGN}
  )
endfunction()
