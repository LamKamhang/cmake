include_guard()

# check toplevel_project
function(lam_check_toplevel_project out_name)
  if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(${out_name} ON PARENT_SCOPE)
  else()
    set(${out_name} OFF PARENT_SCOPE)
  endif()
endfunction()

function(lam_assert_not_build_in_source_path)
  if (PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
  endif()
endfunction()

# include may have side-effect, so use macro here.
macro(lam_may_include file)
  if (EXISTS ${file})
    message(DEBUG "[cmake/utility] may_include: ${file}")
    include(${file})
  endif()
endmacro()

function(lam_get_subdirs result basedir)
  lam_verbose_func()

  file(GLOB children RELATIVE ${basedir} ${basedir}/*)
  set(dirlist "")
  foreach(child ${children})
    if (IS_DIRECTORY "${basedir}/${child}")
      list(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist} PARENT_SCOPE)
endfunction()

function(lam_is_version out v)
  lam_verbose_func()

  # major[.minor[.patch[.tweak]]]
  if (${v} MATCHES "^[0-9]+(\\.[0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?$")
    set(${out} YES PARENT_SCOPE)
  else()
    set(${out} NO PARENT_SCOPE)
  endif()
endfunction()

function(lam_infer_version_from_tag out tag)
  lam_verbose_func()

  # extract version pattern from tag.
  # NOTE: to avoid mismatching, here assume that the version at least
  #       contains major.minor[.patch[.tweak]] part.
  if (${tag} MATCHES "[0-9]+\\.[0-9]+(\\.[0-9]+)?(\\.[0-9]+)?")
    lam_debug("matched version: ${CMAKE_MATCH_0}") # the matched part.
    set(${out} ${CMAKE_MATCH_0} PARENT_SCOPE)
  else()
    unset(${out} PARENT_SCOPE)
    lam_debug("infer version failed: ${tag}")
  endif()
endfunction()

function(lam_convert_cmake_args_to_options out cmake_args)
  set(result "")
  foreach(arg ${cmake_args})
    if (${arg} MATCHES "^-D([^ ]+)(:[^ ]+)?=([^ ]+)$")
      lam_debug("Key: ${CMAKE_MATCH_1}, Value: ${CMAKE_MATCH_3}, Type: ${CMAKE_MATCH_2}")
      set(result ${result} "${CMAKE_MATCH_1} ${CMAKE_MATCH_3}")
    else()
      lam_fatal("Unknown cmake_arg: ${arg}, should be specified as: -D<var>[:<type>]=<value>")
    endif()
  endforeach()
  lam_debug("Converted CMakeArgs:  ${result}")

  set(${out} ${result} PARENT_SCOPE)
endfunction()

function(lam_get_cxx_compiler_name out)
  # only get the major version.
  string(REGEX MATCHALL "[0-9]+" COMPILER_VERSION_COMPONENTS ${CMAKE_CXX_COMPILER_VERSION})
  list(GET COMPILER_VERSION_COMPONENTS 0 COMPILER_MAJOR_VERSION)

  lam_debug("COMPILER_MAJOR_VERSION: ${COMPILER_MAJOR_VERSION}")

  if ("${COMPILER_MAJOR_VERSION}" STREQUAL "")
    set(${out} ${CMAKE_CXX_COMPILER_ID} PARENT_SCOPE)
  else()
    set(${out} ${CMAKE_CXX_COMPILER_ID}-${COMPILER_MAJOR_VERSION} PARENT_SCOPE)
  endif()
endfunction()

function(lam_get_latest_tag_of_a_git_repo url num)
  find_package(Git REQUIRED)
  lam_assert_defined(GIT_EXECUTABLE)

  execute_process(
    COMMAND ${GIT_EXECUTABLE} ls-remote --tags --refs --sort=-v:refname ${url}
    OUTPUT_VARIABLE tags
  )

  string(REPLACE "\n" ";" tags "${tags}")

  if (NOT "${tags}" STREQUAL "")
    foreach(i RANGE ${num})
      if (${i} EQUAL ${num})
        break()
      endif()
      list(GET tags ${i} tag)
      string(REGEX REPLACE "^.*refs/tags/" "" tag "${tag}")
      lam_status("latest(${url}).tag${i}: ${tag}")
    endforeach()
  endif()
endfunction()

# Stack mechanism to set/unset variable
macro(lam_push_variable var value)
  if (DEFINED ${var})
    list(APPEND __${var}_STACK "${${var}}")
  endif()
  set(${var} "${value}")
endmacro()

macro(lam_pop_variable var)
  list(LENGTH __${var}_STACK N_OLD_VALUES)
  if (${N_OLD_VALUES} EQUAL 0)
    unset(${var})
  else()
    list(POP_BACK __${var}_STACK ${var})
  endif()
endmacro()
