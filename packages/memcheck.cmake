find_program(VALGRIND valgrind)
if (VALGRIND)
  message(STATUS "valgrind find: ${VALGRIND}")
else()
  message(FATAL_ERROR "valgrind not found! please set {VALGRIND_ROOT} correctly!")
endif()

add_custom_target(
    memcheck)

function(add_memcheck prog)
  add_custom_command(
    TARGET memcheck
    COMMAND ${VALGRIND}
    --tool=memcheck
    --leak-check=full
    --show-reachable=yes
    --show-error-list=yes
    --error-exitcode=1
    $<TARGET_FILE:${prog}>
    DEPENDS ${prog})
endfunction()
