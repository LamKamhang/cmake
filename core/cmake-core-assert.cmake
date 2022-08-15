macro(DEBUG_MSG)
  if (DEBUG_MODE)
    message("[DEBUG] ${ARGV}")
  endif()
endmacro()

macro(ERROR_MSG)
  message(FATAL_ERROR "${ARGV}")
endmacro()

function(ASSERT_EQUAL)
  if(NOT ARGC EQUAL 2)
    ERROR_MSG("assertion failed: invalid argument count: ${ARGC}")
  endif()

  if(NOT "${ARGV0}" STREQUAL "${ARGV1}")
    ERROR_MSG("assertion failed: '${ARGV0}' != '${ARGV1}'")
  endif()
endfunction()

function(ASSERT_NOT_EQUAL)
  if(NOT ARGC EQUAL 2)
    ERROR_MSG("assertion failed: invalid argument count: ${ARGC}")
  endif()

  if("${ARGV0}" STREQUAL "${ARGV1}")
    ERROR_MSG("assertion failed: '${ARGV0}' == '${ARGV1}'")
  endif()
endfunction()

function(ASSERT_EMPTY)
  if(NOT ARGC EQUAL 0)
    ERROR_MSG("assertion failed: input ${ARGC} not empty: '${ARGV}'")
  endif()
endfunction()

function(ASSERT_DEFINED)
  DEBUG_MSG("ASSERT_DEFINED.ARGV: ${ARGV}")
  foreach(KEY ${ARGV})
    DEBUG_MSG("AssertDefined.Current.key: ${KEY}")
    if(NOT DEFINED ${KEY})
      ERROR_MSG("assertion failed: '${KEY}' is not defiend")
    endif()
  endforeach()
endfunction()

function(ASSERT_NOT_DEFINED)
  DEBUG_MSG("ASSERT_NOT_DEFINED.ARGV: ${ARGV}")
  foreach(KEY ${ARGV})
    DEBUG_MSG("AssertNotDefined.Current.Key: ${KEY}")
    if (DEFINED ${KEY})
      ERROR_MSG("assertion failed: '${KEY}' is defiend (${${KEY}})")
    endif()
  endforeach()
endfunction()

function(ASSERT_TRUTHY KEY)
  if(NOT ${${KEY}})
    ERROR_MSG("assertion failed: value of '${KEY}' is not truthy (${${KEY}})")
  endif()
endfunction()

function(ASSERT_FALSY KEY)
  if(${${KEY}})
    ERROR_MSG("assertion failed: value of '${KEY}' is not falsy (${${KEY}})")
  endif()
endfunction()

function(ASSERTION_FAILED)
  ERROR_MSG("assertion failed: ${ARGN}")
endfunction()

function(ASSERT_EXISTS)
  DEBUG_MSG("ASSERT_EXISTS.ARGV: ${ARGV}")
  foreach(FILE ${ARGV})
    DEBUG_MSG("ASSERT_EXISTS.Current.file: ${FILE}")
    if (NOT EXISTS ${FILE})
      ERROR_MSG("assertion failed: file ${FILE} does not exist")
    endif()
  endforeach()
endfunction()

function(ASSERT_NOT_EXISTS)
  DEBUG_MSG("ASSERT_NOT_EXISTS.ARGV: ${ARGV}")
  foreach(FILE ${ARGV})
    DEBUG_MSG("ASSERT_NOT_EXISTS.Curreny.file: ${FILE}")
    if(EXISTS ${FILE})
      ERROR_MSG("assertion failed: file ${FILE} exists")
    endif()
  endforeach()
endfunction()
