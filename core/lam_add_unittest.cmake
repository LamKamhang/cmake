include_guard()

use_cmake_core_module(lam_assert)
use_cmake_core_module(lam_utils)
use_cmake_core_module(lam_add_target)
use_cmake_core_module(lam_package_cpm)

function(lam_add_unittest name)
  if (NOT TARGET Catch2::Catch2)
    lam_use_deps(catch2)
  endif()

  set(options CUSTOM_MAIN DISABLE_DEFAULT_GLOB)
  set(oneValueArgs "")
  set(multiValueArgs "GLOB_SRCS;SRCS")
  cmake_parse_arguments(OPTIONS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if (NOT OPTIONS_DISABLE_GLOB)
    set(UNITTEST_GLOB_PATTERN
      "unittest/*.cc" "unittest/*.hh" "unittest/*.[ch]pp" "unittest/*.[ch]xx"
    )
  endif()

  if (DEFINED OPTIONS_GLOB_SRCS)
    list(APPEND UNITTEST_GLOB_PATTERN ${OPTIONS_GLOB_SRCS})
  endif()
  file(GLOB_RECURSE UNIT_SRCS ${UNITTEST_GLOB_PATTERN})
  if (DEFINED OPTIONS_SRCS)
    list(APPEND UNIT_SRCS ${OPTIONS_SRCS})
  endif()

  list(LENGTH UNIT_SRCS NUM_OF_FILES)
  if (${NUM_OF_FILES} EQUAL 0)
    message(STATUS "skip ${name}, cannot find any source file.")
    return()
  endif()

  if (TARGET ${name})
      lam_add_target(${name}
        APPEND_SOURCE
        SRCS ${UNIT_SRCS}
        ${OPTIONS_UNPARSED_ARGUMENTS}
      )
  else()
    lam_add_target(${name}
      SRCS ${UNIT_SRCS}
      ${OPTIONS_UNPARSED_ARGUMENTS}
    )

    if (NOT OPTIONS_CUSTOM_MAIN)
      target_link_libraries(${name} PRIVATE Catch2::Catch2WithMain)
    else()
      target_link_libraries(${name} PRIVATE Catch2::Catch2)
    endif()

    set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/unittest")
    # Register tests.
    catch_discover_tests(${name})
  endif()
endfunction()
