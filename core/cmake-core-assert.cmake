cmake_minimum_required(VERSION 3.17)

include_guard()

macro(DEBUG_MSG)
  if(DEBUG_MODE)
    message("[DEBUG] ${ARGV}")
  endif()
endmacro()

macro(WARN_MSG)
  message(WARNING ${ARGV})
endmacro()

macro(ERROR_MSG)
  message(FATAL_ERROR "${ARGV}")
endmacro()

function(ASSERT_EQUAL LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  # both work in string equal or number equal.
  # quote "" is required.
  if(NOT "${LHS}" STREQUAL "${RHS}")
    ERROR_MSG("assertion failed: '${LHS}' == '${RHS}'")
  endif()
endfunction()

function(ASSERT_NOT_EQUAL LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  if("${LHS}" STREQUAL "${RHS}")
    ERROR_MSG("assertion failed: '${LHS}' != '${RHS}'")
  endif()
endfunction()

function(ASSERT_LESS LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  if(NOT "${LHS}" LESS ${RHS})
    ERROR_MSG("assertion failed: '${LHS} < ${RHS}'")
  endif()
endfunction()

function(ASSERT_LESS_EQUAL LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  if(NOT "${LHS}" LESS_EQUAL ${RHS})
    ERROR_MSG("assertion failed: '${LHS} <= ${RHS}'")
  endif()
endfunction()

function(ASSERT_GREATER LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  if(NOT "${LHS}" GREATER ${RHS})
    ERROR_MSG("assertion failed: '${LHS} > ${RHS}'")
  endif()
endfunction()

function(ASSERT_GREATER_EQUAL LHS RHS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${LHS}, ${RHS}")

  if(NOT "${LHS}" GREATER_EQUAL ${RHS})
    ERROR_MSG("assertion failed: '${LHS} >= ${RHS}'")
  endif()
endfunction()

function(ASSERT_NOT_LESS LHS RHS)
  ASSERT_GREATER_EQUAL(${LHS} ${RHS})
endfunction()

function(ASSERT_NOT_LESS_EQUAL LHS RHS)
  ASSERT_GREATER(${LHS} ${RHS})
endfunction()

function(ASSERT_NOT_GREATER LHS RHS)
  ASSERT_LESS_EQUAL(${LHS} ${RHS})
endfunction()

function(ASSERT_NOT_GREATER_EQUAL LHS RHS)
  ASSERT_LESS(${LHS} ${RHS})
endfunction()

function(ASSERT_LIST_SIZE VAR SIZE)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")
  ASSERT_EQUAL(${ARGC} 2)
  list(LENGTH ${VAR} NUM)

  if(NOT NUM EQUAL SIZE)
    ERROR_MSG("assertion failed: ${VAR}: (${${VAR}}).size != ${SIZE}")
  endif()
endfunction()

function(ASSERT_LIST_LE_SIZE VAR SIZE)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")
  ASSERT_EQUAL(${ARGC} 2)
  list(LENGTH ${VAR} NUM)

  if(NOT NUM LESS_EQUAL SIZE)
    ERROR_MSG("assertion failed: ${VAR}: (${${VAR}}).size != ${SIZE}")
  endif()
endfunction()

function(ASSERT_EMPTY VAR)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")
  ASSERT_LIST_SIZE(${VAR} 0)
endfunction()

function(ASSERT_NOT_EMPTY VAR)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")
  ASSERT_EQUAL(${ARGC} 1)
  list(LENGTH ${VAR} NUM)

  if(NUM EQUAL 0)
    ERROR_MSG("assertion failed: ${VAR}:(${${VAR}}) is empty.")
  endif()
endfunction()

function(ASSERT_DEFINED)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(KEY ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${KEY}")

    if(NOT DEFINED ${KEY})
      ERROR_MSG("assertion failed: '${KEY}' is not defiend")
    endif()
  endforeach()
endfunction()

function(ASSERT_NOT_DEFINED)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(KEY ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${KEY}")

    if(DEFINED ${KEY})
      ERROR_MSG("assertion failed: '${KEY}' is defiend (${${KEY}})")
    endif()
  endforeach()
endfunction()

function(ASSERT_TRUTHY KEY)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  if(NOT ${KEY})
    ERROR_MSG("assertion failed: value of '${KEY}' is not truthy.")
  endif()
endfunction()

function(ASSERT_FALSY KEY)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  if(${KEY})
    ERROR_MSG("assertion failed: value of '${KEY}' is not falsy.")
  endif()
endfunction()

function(ASSERT_EXISTS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(FILE ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${FILE}")
    get_filename_component(FILE ${FILE} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: abs(${FILE})")

    # relative to abslute based on current_list_dir.
    if(NOT EXISTS ${FILE})
      ERROR_MSG("assertion failed: file `${FILE}` does not exist")
    endif()
  endforeach()
endfunction()

function(ASSERT_NOT_EXISTS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(FILE ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${FILE}")
    get_filename_component(FILE ${FILE} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: abs(${FILE})")

    if(EXISTS ${FILE})
      ERROR_MSG("assertion failed: file `${FILE}` exists")
    endif()
  endforeach()
endfunction()

function(ASSERT_PATH_EXISTS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(PATH ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${PATH}")
    get_filename_component(PATH ${PATH} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: abs(${PATH})")

    # set(bkp ${DEBUG_MODE})
    # set(DEBUG_MODE FALSE)
    # ASSERT_EXISTS(${PATH})
    # set(DEBUG_MODE ${bkp})
    if(NOT IS_DIRECTORY ${PATH})
      ERROR_MSG("${CMAKE_CURRENT_FUNCTION} failed: ${PATH} is not a directory.")
    endif()
  endforeach()
endfunction()

function(ASSERT_FILE_EXISTS)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}: ${ARGV}")

  foreach(FILE ${ARGV})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: ${FILE}")
    get_filename_component(FILE ${FILE} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    DEBUG_MSG("  ${CMAKE_CURRENT_FUNCTION}: abs(${FILE})")
    set(bkp ${DEBUG_MODE})
    set(DEBUG_MODE FALSE)
    ASSERT_EXISTS(${FILE})
    set(DEBUG_MODE ${bkp})

    if(IS_DIRECTORY ${FILE})
      ERROR_MSG("${CMAKE_CURRENT_FUNCTION} failed: ${FILE} is not a file.")
    endif()
  endforeach()
endfunction()
