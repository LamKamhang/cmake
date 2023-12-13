include_guard()

if (NOT LAM_USE_MEMCHECK)
  return()
endif()

message(STATUS "[cmake/memcheck]: Enable valgrind.")

find_program(VALGRIND valgrind)

if(VALGRIND)
  message(STATUS "valgrind find: ${VALGRIND}")
else()
  message(FATAL_ERROR "valgrind not found! please set {VALGRIND_ROOT} correctly!")
endif()

function(add_memcheck prog)
  if(NOT TARGET memcheck)
    add_custom_target(memcheck)
  endif()

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
