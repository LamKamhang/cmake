include_guard()

option(LAM_ENABLE_ERROR_KEEP_GOING "enable lam_error() keep going" OFF)
set(lam_debug_indent " |")
set(lam_status_indent "")

function(lam_status)
  message(STATUS "${lam_status_indent}${ARGV}")
endfunction()

function(lam_debug)
  message(DEBUG "[debug]${lam_debug_indent}${ARGV}")
endfunction()

function(lam_warn)
  message(WARNING "${ARGV}")
endfunction()

function(lam_error)
  if (LAM_ENABLE_ERROR_KEEP_GOING)
    message(SEND_ERROR "${ARGV}")
  else()
    message(FATAL_ERROR "${ARGV}")
  endif()
endfunction()

function(lam_fatal)
  message(FATAL_ERROR "${ARGV}")
endfunction()

##############################################################################
# NOTE: cmake's macro is a very very counter-intuitive thing,
#       you must pay attention when using it.
# Here just use a HACK to perform verbosing.
# ARGN, ARGC, ARGV and ARGV# are not true variables in macro.
# any dereference of them with indirectly would replaced with the neareat true variable.
# For example, the following case:
#
# macro(bar argc)
#   lam_debug("in bar.direct: ${ARGV0}") # ==> 1
#   foreach(i RANGE ${argc})
#     if (${i} EQUAL ${argc})
#       break()
#     endif()
#     lam_debug("in bar: ${ARGV${i}}") # ==> 1;1
#   endforeach()
# endmacro()
#
# macro(foo)
#   lam_debug("in foo.direct: ${ARGV0}") # ==> 1;1;2
#   bar(${ARGC})
# endmacro()
#
# function(func a b)
#   lam_debug("in func.direct: ${ARGV0}") # ==> 1;1
#   foo("${ARGV}")
# endfunction()
#
# func("1;1" 2)
#
# Use such "feature" to do this verbose.
# NOTE: ${ARGV${}} is a hack to disable macro text replacement.
macro(lam_verbose_func)
  set(lam_debug_indent "${lam_debug_indent}-")
  set(__argc ${ARGC${}})
  set(__argv ${ARGV${}})
  lam_debug("calling: ${CMAKE_CURRENT_FUNCTION}(${__argv})")
  lam_debug("  ARGC: ${__argc}")
  foreach(i RANGE ${__argc})
    if (${i} EQUAL ${__argc})
      break()
    endif()
    lam_debug("  ARGV${i}: ${ARGV${i}}")
  endforeach()
  unset(__argc)
  unset(__argv)
endmacro()

macro(__lam_assert expr)
  if (${__passed})
    lam_debug("assertion [${CMAKE_CURRENT_FUNCTION}|${expr}] passed.")
  else()
    lam_error("assertion [${CMAKE_CURRENT_FUNCTION}|${expr}] failed.")
  endif()
endmacro()
##############################################################################
# Assertion for numbers
##############################################################################
function(lam_assert_num_equal LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" EQUAL "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"==\"${RHS}\"")
endfunction()

function(lam_assert_not_num_equal LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if (NOT ("${LHS}" EQUAL "${RHS}"))
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"!=\"${RHS}\"")
endfunction()

function(lam_assert_num_lt LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" LESS "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"<\"${RHS}\"")
endfunction()

function(lam_assert_num_le LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" LESS_EQUAL "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"<=\"${RHS}\"")
endfunction()

function(lam_assert_num_gt LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" GREATER "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\">\"${RHS}\"")
endfunction()

function(lam_assert_num_ge LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" GREATER_EQUAL "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\">=\"${RHS}\"")
endfunction()
##############################################################################
# Assertion for string
##############################################################################
function(lam_assert_str_equal LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" STREQUAL "${RHS}")
    set(__passed TRUE)
  endif()
   __lam_assert("\"${LHS}\"==\"${RHS}\"")
endfunction()

function(lam_assert_str_not_equal LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if (NOT ("${LHS}" STREQUAL "${RHS}"))
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"!=\"${RHS}\"")
endfunction()

macro(lam_assert_equal LHS RHS)
  lam_assert_str_equal("${LHS}" "${RHS}")
endmacro()

macro(lam_assert_not_equal LHS RHS)
  lam_assert_str_not_equal("${LHS}" "${RHS}")
endmacro()

function(lam_assert_str_lt LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" STRLESS "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"<\"${RHS}\"")
endfunction()

function(lam_assert_str_le LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" STRLESS_EQUAL "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\"<=\"${RHS}\"")
endfunction()

function(lam_assert_str_gt LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" STRGREATER "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\">\"${RHS}\"")
endfunction()

function(lam_assert_str_ge LHS RHS)
  lam_verbose_func()

  set(__passed FALSE)
  if ("${LHS}" STRGREATER_EQUAL "${RHS}")
    set(__passed TRUE)
  endif()
  __lam_assert("\"${LHS}\">=\"${RHS}\"")
endfunction()
##############################################################################
# Assertion for boolean
##############################################################################
function(lam_assert_truthy)
  lam_verbose_func()

  foreach(_arg ${ARGV})
    set(__passed FALSE)
    if (${_arg})
      set(__passed TRUE)
    endif()
    __lam_assert("key(${_arg}) should be TRUE/ON/YES")
  endforeach()
endfunction()

function(lam_assert_falsy)
  lam_verbose_func()

  foreach(_arg ${ARGV})
    set(__passed FALSE)
    if (NOT ${_arg})
      set(__passed TRUE)
    endif()
    __lam_assert("key(${_arg}) should be FALSE/NO/OFF")
  endforeach()
endfunction()
##############################################################################
# Assertion for lists
##############################################################################
# NOTE: The VAR's name cannot be VAR/SIZE
function(lam_assert_list_size_var VAR SIZE)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  set(__passed FALSE)
  list(LENGTH ${VAR} N_TERMS)
  if (${N_TERMS} EQUAL ${SIZE})
    set(__passed TRUE)
  endif()
  __lam_assert("(${VAR}:=[${${VAR}}]).size(${N_TERMS})==${SIZE}")
endfunction()

function(lam_assert_list_size_lt_var VAR SIZE)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  set(__passed FALSE)
  list(LENGTH ${VAR} N_TERMS)
  if (${N_TERMS} LESS ${SIZE})
    set(__passed TRUE)
  endif()
  __lam_assert("(${VAR}:=[${${VAR}}]).size(${N_TERMS})<${SIZE}")
endfunction()

function(lam_assert_list_size_gt_var VAR SIZE)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  set(__passed FALSE)
  list(LENGTH ${VAR} N_TERMS)
  if (${N_TERMS} GREATER ${SIZE})
    set(__passed TRUE)
  endif()
  __lam_assert("(${VAR}:=[${${VAR}}]).size(${N_TERMS})>${SIZE}")
endfunction()

function(lam_assert_not_empty_var) #extend to arg_list
  lam_verbose_func()
  foreach(__arg ${ARGV})
    lam_assert_list_size_gt_var(${__arg} 0)
  endforeach()
endfunction()

# NOTE: LIST SHOULD BE THE VALUE OF SOME VAR.
function(lam_assert_list_size LIST SIZE)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  lam_assert_list_size_var(LIST ${SIZE})
endfunction()

function(lam_assert_defined) # passed in a list of variable's name.
  lam_verbose_func()

  foreach(KEY ${ARGV})
    lam_debug("  current.key: ${KEY}")

    set(__passed FALSE)
    if (DEFINED ${KEY})
      set(__passed TRUE)
    endif()
    __lam_assert("${KEY} should be defined.")
  endforeach()
endfunction()

function(lam_assert_not_defined)
  lam_verbose_func()

  foreach(KEY ${ARGV})
    set(__passed FALSE)
    if (NOT DEFINED ${KEY})
      set(__passed TRUE)
    endif()
    __lam_assert("${KEY} should *NOT* be defined.")
  endforeach()
endfunction()

##############################################################################
# Assertion for file/path
##############################################################################
macro(__path_helper)
  lam_debug("current.path: ${PATH}")
  # convert relative path to abspath.
  # since EXISTS check doesn't for relative path.
  get_filename_component(PATH ${PATH} REALPATH BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
  lam_debug("realpath: ${PATH}")
endmacro()

function(lam_assert_exists) # pass in a list of file which needs to check whether exists.
  lam_verbose_func()
  foreach(PATH ${ARGV})
    __path_helper()
    set(__passed FALSE)
    if (EXISTS ${PATH})
      set(__passed TRUE)
    endif()
    __lam_assert("path(${PATH}) should exist.")
  endforeach()
endfunction()

function(lam_assert_not_exists) # pass in a list of file which needs to check whether exists.
  lam_verbose_func()
  foreach(PATH ${ARGV})
    __path_helper()
    set(__passed FALSE)
    if (NOT EXISTS ${PATH})
      set(__passed TRUE)
    endif()
    __lam_assert("path(${PATH}) should *NOT* exist.")
  endforeach()
endfunction()

function(lam_assert_dir_exists) # pass in a list of file which needs to check whether exists.
  lam_verbose_func()
  foreach(PATH ${ARGV})
    __path_helper()
    set(__passed FALSE)
    if (IS_DIRECTORY ${PATH})
      set(__passed TRUE)
    endif()
    __lam_assert("path(${PATH}) should exist and be a directory.")
  endforeach()
endfunction()

function(lam_assert_file_exists) # pass in a list of file which needs to check whether exists.
  lam_verbose_func()
  foreach(PATH ${ARGV})
    __path_helper()
    set(__passed FALSE)
    if ((NOT IS_DIRECTORY ${PATH}) AND (EXISTS ${PATH}))
      set(__passed TRUE)
    endif()
    __lam_assert("path(${PATH}) should exist and be a file.")
  endforeach()
endfunction()

function(lam_assert_target_defined)
  lam_verbose_func()
  foreach(target ${ARGV})
    set(__passed FALSE)
    if (TARGET ${target})
      set(__passed TRUE)
    endif()
    __lam_assert("target(${target}) should be defiend.")
  endforeach()
endfunction()

function(lam_assert_target_not_defined)
  lam_verbose_func()
  foreach(target ${ARGV})
    set(__passed FALSE)
    if (NOT TARGET ${target})
      set(__passed TRUE)
    endif()
    __lam_assert("target(${target}) should *NOT* be defiend.")
  endforeach()
endfunction()
