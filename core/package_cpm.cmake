include_guard()

use_cmake_core_module(assert)
register_cmake_module_path(packages)

########################################################################
# Use CPM.cmake instead.
if (NOT DEFINED ENV{CPM_SOURCE_CACHE})
  set(ENV{CPM_SOURCE_CACHE} ${CMAKE_SOURCE_DIR}/external)
endif()

set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)
########################################################################
# Options/CacheVariables
########################################################################
# status helper
macro(lam_pkg_status)
  set(lam_status_indent "[lam_package] ")
  lam_status(${ARGV})
endmacro()
########################################################################
option(LAM_PACKAGE_OVERRIDE_FIND_PACKAGE "override find_package with verbose" ON)
option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." ON)
option(LAM_PACKAGE_PREFER_PREBUILD "prefer prebuild mode(install and then find strategy)" ON)
option(LAM_PACKAGE_VERBOSE_INSTALL "enable verbose ExternalPackage" ON)
option(LAM_PACKAGE_BUILD_SHARED "External Package Build as a shared lib" ON)

set(LAM_PACKAGE_BUILD_TYPE "${CMAKE_BUILD_TYPE}"
  CACHE STRING "Default ExternalPackage BuildType"
)
if ("${LAM_PACKAGE_BUILD_TYPE}" STREQUAL "")
  set(LAM_PACKAGE_BUILD_TYPE "Release")
endif()
# BuildType to lowercase.
string(TOLOWER ${LAM_PACKAGE_BUILD_TYPE} LAM_PACKAGE_BUILD_TYPE_LC)
lam_status("ExternalBuildType: ${LAM_PACKAGE_BUILD_TYPE}")

set(LAM_PACKAGE_INSTALL_PREFIX ${CPM_SOURCE_CACHE}/installed/${LAM_PACKAGE_BUILD_TYPE_LC}
  CACHE PATH "Directory to install external package."
)

set(LAM_PACKAGE_NUM_THREADS 0 CACHE STRING "Number of Threads used to compile.")
if (${LAM_PACKAGE_NUM_THREADS} LESS 1)
  include(ProcessorCount)
  ProcessorCount(LAM_PACKAGE_NUM_THREADS)
endif()
lam_pkg_status("#THreads: ${LAM_PACKAGE_NUM_THREADS}")
########################################################################
# Core Implementation
########################################################################
# Utils Part
########################################################################
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

# TODO: if the uri is archive type, then the out-name may not correct.
function(lam_get_name_from_uri out uri)
  lam_verbose_func()

  # trim tailing.
  string(REGEX REPLACE "#(.*)$" "" uri ${uri})
  string(REGEX REPLACE "@([0-9.]*)$" "" uri ${uri})
  string(REGEX REPLACE "\\.git$" "" uri ${uri})
  lam_debug("uri after triming: ${uri}")

  if (${uri} MATCHES "[^/:]+$")
    lam_debug("infer name: ${CMAKE_MATCH_0}")
    set(${out} ${CMAKE_MATCH_0} PARENT_SCOPE)
  else()
    lam_fatal("cannot get name from uri")
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

function(lam_assert_valid_uri uri)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 1)

  if (${uri} MATCHES " ")
    lam_error("uri [${uri}] cannot has SPACE.")
  elseif(${uri} MATCHES "#[^#]*#")
    lam_error("uri [${uri}] cannot has more than 1 '#'")
  elseif(${uri} MATCHES "@[0-9.]*(#[^#]*)?@[0-9.]*")
    lam_error("uri [${uri}] cannot has more than 1 '@[0-9.]*' to define version part")
  endif()
endfunction()

# split uri into three part: url#tag@version
function(lam_split_uri uri)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 1)
  lam_assert_valid_uri(${uri})

  # get tag-version part.
  # @#xxx$ and #xxx@$ to disbable version infering.
  if (${uri} MATCHES "(@([0-9.]*))?(#([^@]*))?(@([0-9.]*))?$")
    set(at_v1 ${CMAKE_MATCH_1})
    set(v1 ${CMAKE_MATCH_2})
    set(tag ${CMAKE_MATCH_4})
    set(at_v2 ${CMAKE_MATCH_5})
    set(v2 ${CMAKE_MATCH_6})
    if ("${at_v1}${at_v2}" STREQUAL "") # infer from tag.
      # "" quote tag to avoid empty var.
      lam_infer_version_from_tag(version "${tag}")
    elseif("${at_v1}" STREQUAL "")
      set(version ${v2})
    elseif("${at_v2}" STREQUAL "")
      set(version ${v1})
    else()
      lam_error("cannot set version with multiple @[0-9.]*")
    endif()
  endif()
  # trim tag[version] part.
  string(REGEX REPLACE "#(.*)$" "" uri ${uri})
  string(REGEX REPLACE "@[0-9.]*$" "" url ${uri})
  lam_debug("uri after triming tag version: ${url}")

  lam_debug("split.url: ${url}")
  lam_debug("split.tag: ${tag}")
  lam_debug("split.version: ${version}")

  # pop variable out.
  set(lam_pkg_url ${url} PARENT_SCOPE)
  set(lam_pkg_tag ${tag} PARENT_SCOPE)
  set(lam_pkg_version ${version} PARENT_SCOPE)
endfunction()

macro(__lam_check_url url)
  if (${url} MATCHES "@[0-9.]*$")
    lam_warn("This is split_url function, DONT pass uri hedre, now just simply trim the version part.")
    string(REGEX REPLACE "@[0-9.]*$" "" url ${url})
  endif()
  if(${url} MATCHES "#")
    lam_warn("This is split_url function, DONT pass uri here, now just simply trim the tag part.")
    string(REGEX REPLACE "#(.*)$" "" url ${url})
  endif()
  if (${url} MATCHES "@[0-9.]*$")
    lam_warn("This is split_url function, DONT pass uri hedre, now just simply trim the version part.")
    string(REGEX REPLACE "@[0-9.]*$" "" url ${url})
  endif()
endmacro()

function(lam_split_url url)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 1)
  lam_assert_valid_uri(${url})
  __lam_check_url(${url})
  lam_debug("url after checking: ${url}")

  # output type, url
  if (${url} MATCHES "^([^:]+):(.+)$")
    string(TOLOWER "${CMAKE_MATCH_1}" scheme)
    set(path ${CMAKE_MATCH_2})
    lam_debug("scheme: ${scheme}")
    lam_debug("rest: ${path}")
  endif()

  # some special schemes
  if (scheme STREQUAL "rom") # ryon.ren:mirrors
    set(type git)
    lam_get_name_from_uri(name ${url})
    set(url ssh://git@ryon.ren:10022/mirrors/${name})
  elseif(scheme STREQUAL "gh") # github
    set(type git)
    set(url https://github.com/${path})
  elseif(scheme STREQUAL "gl") # gitlab
    set(type git)
    set(url https://gitlab.com/${path})
  elseif(scheme STREQUAL "bb") # bitbucket
    set(type git)
    set(url https://bitbucket.org/${path})
  else()
    # normal test.
    if("${url}" MATCHES "\\.git$" # end with .git
        OR "${url}" MATCHES "^(ssh://)?git@" # start with [ssh://]git@
        # https://github.com/Username/RepoName
        OR "${url}" MATCHES "^https://github\\.com/[^/ ]+/[^/ ]+$"
        # https://gitlab.com/Username/RepoName
        OR "${url}" MATCHES "^https://gitlab\\.com/[^/ ]+/[^/ ]+$"
        # https://bitbucket.org/Username/RepoName
        OR "${url}" MATCHES "^https://bitbucket\\.org/[^/ ]+/[^/ ]+$"
        # https://ryon.ren/Username/RepoName
        OR "${url}" MATCHES "^https://ryon\\.ren(:2443)?/[^/ ]+/[^/ ]+$"
        OR "${url}" MATCHES "^https://funannongwu\\.com/[^/ ]+/[^/ ]+$")
      set(type git)
      # keep url not changed.
    else() # FIXME: other protocol: svn, cvs.
      set(type archive)
    endif()
  endif()

  if (NOT "${type}" STREQUAL "archive")
    lam_get_name_from_uri(name ${url})
    set(lam_pkg_name ${name} PARENT_SCOPE)
  endif()
  set(lam_pkg_url ${url} PARENT_SCOPE)
  set(lam_pkg_type ${type} PARENT_SCOPE)
endfunction()

function(lam_extract_args_from_uri out uri)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)
  lam_assert_valid_uri(${uri})

  # Step1. split uri
  lam_split_uri(${uri}) # would define lam_pkg_url, lam_pkg_tag, lam_pkg_version.
  lam_assert_defined(lam_pkg_url)

  # Step2. split url.
  lam_split_url(${lam_pkg_url}) # would defined lam_pkg_type, lam_pkg_real_url.
  lam_assert_defined(lam_pkg_type lam_pkg_url)
  lam_debug("type: ${lam_pkg_type}")
  lam_debug("url: ${lam_pkg_url}")
  if (NOT "${lam_pkg_type}" STREQUAL "archive")
    lam_assert_defined(lam_pkg_name)
    set(lam_pkg_name ${lam_pkg_name} PARENT_SCOPE)
  endif()

  # prepare extracted args.
  if ("${lam_pkg_type}" STREQUAL "git")
    set(args GIT_REPOSITORY ${lam_pkg_url})
    if (DEFINED lam_pkg_tag)
      set(args ${args} GIT_TAG ${lam_pkg_tag} GIT_SHALLOW ON)
    endif()
  elseif("${lam_pkg_type}" STREQUAL "archive")
    set(args URL ${lam_pkg_url})
    if (DEFINED lam_pkg_tag)
      set(args ${args} URL_HASH ${lam_pkg_tag})
    endif()
  else()
    lam_fatal("unknown package type(${lam_pkg_type})")
  endif()

  if (DEFINED lam_pkg_version)
    set(args ${args} VERSION ${lam_pkg_version})
  endif()

  lam_debug("extract_args: ${args}")

  set(${out} ${args} PARENT_SCOPE)
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

function(lam_handle_git_patch cmd patch_file)
  if ("${patch_file}" STREQUAL "")
    unset(${cmd} PARENT_SCOPE)
  else()
    get_filename_component(patch_file "${patch_file}" REALPATH BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
    lam_assert_file_exists("${patch_file}")
    find_package(Git REQUIRED)
    lam_assert_defined(GIT_EXECUTABLE)
    set(${cmd}
      PATCH_COMMAND ${GIT_EXECUTABLE} restore . && ${GIT_EXECUTABLE} apply "${patch_file}"
      PARENT_SCOPE
    )
  endif()
endfunction()

function(lam_add_package uri)
  lam_verbose_func()

  # extract uri from args.
  lam_extract_args_from_uri(extra_args ${uri})

  # extract CMAKE_ARGS from ARGN.
  # you can use END_CMAKE_ARGS to distinguish the other CPM_ARGS
  # from CMAKE_ARGS.
  cmake_parse_arguments(PKG
    "END_CMAKE_ARGS;OPTIONAL"
    "GIT_PATCH;NAME"
    "CMAKE_ARGS"
    "${ARGN}"
  )

  # parse Name.
  if (NOT DEFINED PKG_NAME)
    lam_get_name_from_uri(PKG_NAME ${uri})
  endif()

  # check whether is optional
  if (PKG_OPTIONAL)
    __get_optional_dep_flag(flag ${PKG_NAME})
    if (NOT ${flag})
      return()
    endif()
  endif()

  # change cmake_args to options.
  lam_convert_cmake_args_to_options(OPTIONS "${PKG_CMAKE_ARGS}")
  lam_handle_git_patch(patch_cmd "${PKG_GIT_PATCH}")

  CPMAddPackage(
    EXCLUDE_FROM_ALL YES
    NAME ${PKG_NAME}
    ${extra_args}
    ${patch_cmd}
    ${PKG_UNPARSED_ARGUMENTS}
    OPTIONS ${OPTIONS}
  )
  cpm_export_variables(${PKG_NAME})
endfunction()

macro(lam_optional_package uri)
  lam_add_package(${uri} OPTIONAL ${ARGN})
endmacro()

macro(lam_download_package uri)
  lam_add_package(${uri} DOWNLOAD_ONLY YES ${ARGN})
endmacro()

macro(lam_optional_download_package uri)
  lam_optional_package(${uri} DOWNLOAD_ONLY YES ${ARGN})
endmacro()

# for register packages.
macro(lam_include_package pkg)
  string(TOLOWER ${pkg} __pkg)
  if (EXISTS ${USER_CUSTOM_PACKAGES_DIR}/pkg_${__pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/pkg_${__pkg}.cmake)
  elseif(${USER_CUSTOM_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
  elseif (EXISTS ${_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${__pkg}.cmake)
    include(${_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${__pkg}.cmake)
  elseif(EXISTS ${_CMAKE_UTILITY_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
    include(${_CMAKE_UTILITY_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
  else()
    message(WARNING "package: ${pkg} not found. please provide `pkg_${__pkg}.cmake` to {USER_CUSTOM_PACKAGE_DIR}")
  endif()
  unset(__pkg)
endmacro()

# parse declare_deps format
# [~][!]name[#tag][@version]
# ~ indicate indicate the package is optional.
# '!' indicate whether use prebuild mode.
# tag used to define name_TAG.
# version used to define name_VERSION.
function(lam_parse_deps_format uri out_name)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  string(REGEX REPLACE "^(~)?(!+)?([^@#!]+)" "" tag_version ${uri})
  set(pkg_name ${CMAKE_MATCH_3})
  set(optional_flag ${CMAKE_MATCH_1})
  set(prebuild_flag ${CMAKE_MATCH_2})
  string(REPLACE "~" "YES" optional_flag "${optional_flag}")
  if ("${prebuild_flag}" STREQUAL "")
    unset(prebuild_flag)
  elseif("${prebuild_flag}" STREQUAL "!")
    set(prebuild_flag YES)
  else()
    set(prebuild_flag NO)
  endif()

  lam_debug("name: ${pkg_name}")
  lam_debug("optional: ${optional_flag}")
  lam_debug("prebuild: ${prebuild_flag}")
  lam_debug("tagversion: ${tag_version}")

  unset(pkg_tag)
  unset(pkg_version)
  if ("${tag_version}" MATCHES "^(@(default)?)?$")
    # use default. do not set tag and version.
  elseif (${tag_version} MATCHES "^#([^#]+)$")
    set(pkg_tag ${CMAKE_MATCH_1})
  elseif(${tag_version} MATCHES "^@([0-9.]+)$")
    set(pkg_version ${CMAKE_MATCH_1})
  else()
    lam_error("${uri} is not valid.")
  endif()

  # export variables.
  set(${out_name} ${pkg_name} PARENT_SCOPE)
  set(${pkg_name}_IS_OPTIONAL ${optional_flag} PARENT_SCOPE)
  set(${pkg_name}_USE_PREBUILD ${prebuild_flag} PARENT_SCOPE)
  set(${pkg_name}_TAG ${pkg_tag} PARENT_SCOPE)
  set(${pkg_name}_VERSION ${pkg_version} PARENT_SCOPE)
endfunction()

function(__get_optional_dep_flag out pkg_name)
  string(TOUPPER ${pkg_name} PKG_NAME)
  if (NOT DEFINED OPTIONAL_PKG_PREFIX)
    set(${out} CHAOS_USE_${PKG_NAME} PARENT_SCOPE)
  else()
    set(${out} ${OPTIONAL_PKG_PREFIX}_${PKG_NAME} PARENT_SCOPE)
  endif()
endfunction()

macro(lam_use_deps)
  foreach(dep ${ARGV})
    message(STATUS "[lam_package] current dep: ${dep}")
    lam_parse_deps_format(${dep} dep_name)
    lam_assert_defined(dep_name)

    if (${dep_name}_IS_OPTIONAL)
      __get_optional_dep_flag(__dep_flag_name ${dep_name})
      if (${__dep_flag_name})
        lam_include_package(${dep_name})
      endif()
      unset(__dep_flag_name)
    else()
      lam_include_package(${dep_name})
    endif()
    unset(dep_name)
  endforeach()
endmacro()

function(verbose_find_package PKG)
  # verbose some infos.
  if (${PKG}_FOUND)
    string(TOUPPER ${PKG} tmp)
    if (DEFINED ${${PKG}_VERSION})
      message(STATUS "[package/${PKG}]: find version: ${${PKG}_VERSION}")
    endif()

    if (${tmp}_INCLUDE_DIR)
      message(STATUS "[package/${PKG}]: find_include_dir: ${${tmp}_INCLUDE_DIR}")
    elseif(${tmp}_INCLUDE_DIRS)
      message(STATUS "[package/${PKG}]: find_include_dir: ${${tmp}_INCLUDE_DIRS}")
    endif()
  endif()
endfunction()

if (LAM_PACKAGE_OVERRIDE_FIND_PACKAGE)
  macro(find_package PKG)
    _find_package(${PKG} ${ARGN})
    verbose_find_package(${PKG})
  endmacro()
endif()

macro(lam_export_find_package_variable)
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endmacro()

macro(find_package_ext PKG)
  find_package(${PKG} ${ARGN})
  if (NOT LAM_PACKAGE_OVERRIDE_FIND_PACKAGE)
    verbose_find_package(${PKG})
  endif()
  lam_export_find_package_variable()
endmacro()

# NOTE!! Only Experimentally support!!
# The external package should provide an install target.
# and has a well-designed install and then find strategy.
# Be aware to use this, only for advance user.
# Only for some well known package.
function(lam_add_prebuild_package)
  cmake_parse_arguments(PKG "" "" "CPM_ARGS" ${ARGV})
  set(find_package_args ${PKG_UNPARSED_ARGUMENTS})
  if (NOT DEFINED PKG_CPM_ARGS)
    set(find_package_args)
    set(PKG_CPM_ARGS ${PKG_UNPARSED_ARGUMENTS})
  endif()

  # get package name.
  cmake_parse_arguments(CPM_ARGS "" "NAME" "OPTIONS;CMAKE_ARGS" ${PKG_CPM_ARGS})
  if (NOT DEFINED CPM_ARGS_NAME)
    set(uri ${PKG_CPM_ARGS})
    list(FILTER uri INCLUDE REGEX "^([^#: ]+):([^#@ ]+)(@[0-9.]*)?(#[^#@ ]*)?(@[0-9.]*)?$")
    list(LENGTH uri NUM_URI)
    lam_assert_list_size_var(uri 1)
    lam_get_name_from_uri(CPM_ARGS_NAME ${uri})
  endif()

  lam_status("${CPM_ARGS_NAME} use prebuild-mode.")

  # prepare CMAKE_ARGS for prebuild.
  foreach(arg ${CPM_ARGS_OPTIONS})
    cpm_parse_option("${arg}")
    list(APPEND CPM_ARGS_CMAKE_ARGS "-D${OPTION_KEY}=${OPTION_VALUE}")
  endforeach()

  set(my_origin_parameters ${PKG_CPM_ARGS})
  list(SORT my_origin_parameters)
  string(SHA1 my_origin_hash "${my_origin_parameters}")
  set(PKG_INSTALL_PREFIX ${LAM_PACKAGE_INSTALL_PREFIX}/${CPM_ARGS_NAME}/${my_origin_hash})

  if (LAM_PACKAGE_ENABLE_TRY_FIND)
    find_package_ext(${CPM_ARGS_NAME} ${find_package_args} NO_DEFAULT_PATH
      PATHS ${PKG_INSTALL_PREFIX}
    )
  endif()

  if (${${CPM_ARGS_NAME}_FOUND})
    return()
  endif()

  # download package by cpm.
  lam_download_package(${PKG_CPM_ARGS})

  lam_assert_defined(${CPM_ARGS_NAME}_SOURCE_DIR)

  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -S ${${CPM_ARGS_NAME}_SOURCE_DIR}
    -B${CMAKE_BINARY_DIR}/deps-build/${CPM_ARGS_NAME}
    -G${CMAKE_GENERATOR}
    -DCMAKE_BUILD_TYPE=${LAM_PACKAGE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS=${LAM_PACKAGE_BUILD_SHARED}
    -DCMAKE_INSTALL_PREFIX=${PKG_INSTALL_PREFIX}
    -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
    -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    ${CPM_ARGS_CMAKE_ARGS}
    WORKING_DIRECTORY ${${CPM_ARGS_NAME}_SOURCE_DIR}
    OUTPUT_QUIET
    RESULT_VARIABLE result
  )
  if (result)
    lam_fatal("[lam_package] configure external project(${CPM_ARGS_NAME}) failed: ${result}")
  endif()

  if (NOT LAM_PACKAGE_VERBOSE_INSTALL)
    set(__ARGS OUTPUT_QUIET)
  endif()

  execute_process(
    COMMAND ${CMAKE_COMMAND}
    --build ${CMAKE_BINARY_DIR}/deps-build/${CPM_ARGS_NAME} --target install -j ${LAM_PACKAGE_NUM_THREADS}
    RESULT_VARIABLE result
    ${__ARGS}
  )

  if (result)
    lam_fatal("[lam_package] Failed to install external package(${CPM_ARGS_NAME}): ${result}")
  endif()

  find_package_ext(${CPM_ARGS_NAME} ${find_package_args} NO_DEFAULT_PATH
    PATHS ${PKG_INSTALL_PREFIX}
    REQUIRED
  )
endfunction()

########################################################################
# define some alias
########################################################################
function(lam_check_prefer_prebuild out name)
  # If defined ${name}_USE_PREBUILD and it's ON.
  # or does not defined ${name}_USE_PREBUILD
  # but the global flags LAM_PACKAGE_PREFER_PREBUILD is ON
  if ((DEFINED ${name}_USE_PREBUILD
        AND ${name}_USE_PREBUILD)
      OR
      (NOT DEFINED ${name}_USE_PREBUILD
        AND LAM_PACKAGE_PREFER_PREBUILD))
    set(${out} YES PARENT_SCOPE)
  else()
    set(${out} NO PARENT_SCOPE)
  endif()
endfunction()

function(lam_add_package_maybe_prebuild uri) # args.
  cmake_parse_arguments(PKG "" "NAME" "" "${ARGN}")
  # parse Name.
  if (NOT DEFINED PKG_NAME)
    lam_get_name_from_uri(PKG_NAME ${uri})
  endif()
  # transform to lowercase.
  string(TOLOWER ${PKG_NAME} name)

  lam_check_prefer_prebuild(out ${name})
  if (out)
    lam_add_prebuild_package(${ARGV})
    lam_export_find_package_variable()
  else()
    lam_add_package(${ARGV})
  endif()
endfunction()

macro(require_package)
  lam_add_package(${ARGV})
endmacro()
