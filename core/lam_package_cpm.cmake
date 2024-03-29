include_guard()

use_cmake_core_module(lam_assert)
use_cmake_core_module(lam_utils)
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
function(lam_pkg_status)
  set(lam_status_indent "[cmake/package] ")
  lam_status(${ARGV})
endfunction()
########################################################################
option(LAM_PACKAGE_OVERRIDE_FIND_PACKAGE "override find_package with verbose" ON)
option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." ON)
option(LAM_PACKAGE_ENABLE_DEFAULT_SEARCH_PATH "enable find_package with default search strategy" OFF)
option(LAM_PACKAGE_PREFER_PREBUILT "prefer prebuilt mode(install and then find strategy)" ON)
option(LAM_PACKAGE_VERBOSE_INSTALL "enable verbose ExternalPackage" OFF)
option(LAM_PACKAGE_BUILD_SHARED "External Package Build as a shared lib" OFF)
option(LAM_PACKAGE_BUILD_WITH_PIC "External Package Build with PIC flags" ON)

set(LAM_PACKAGE_BUILD_TYPE "Release" CACHE STRING "Default ExternalPackage BuildType")
if ("${LAM_PACKAGE_BUILD_TYPE}" STREQUAL "")
  set(LAM_PACKAGE_BUILD_TYPE "Release")
endif()
# BuildType to lowercase.
string(TOLOWER ${LAM_PACKAGE_BUILD_TYPE} LAM_PACKAGE_BUILD_TYPE_LC)
lam_pkg_status("ExternalBuildType: ${LAM_PACKAGE_BUILD_TYPE}")

# Set Package Install Prefix.
lam_get_cxx_compiler_name(LAM_COMPILER_NAME)
set(LAM_PACKAGE_INSTALL_PREFIX ${CPM_SOURCE_CACHE}/installed/${LAM_COMPILER_NAME}-${LAM_PACKAGE_BUILD_TYPE_LC}
  CACHE PATH "Directory to install external package."
)
unset(LAM_COMPILER_NAME)

set(LAM_PACKAGE_NUM_THREADS 0 CACHE STRING "Number of Threads used to compile.")
if (${LAM_PACKAGE_NUM_THREADS} LESS 1)
  include(ProcessorCount)
  ProcessorCount(LAM_PACKAGE_NUM_THREADS)
endif()
lam_pkg_status("#Threads: ${LAM_PACKAGE_NUM_THREADS}")
########################################################################
# Core Implementation
########################################################################
# Utils Part
########################################################################
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
  elseif(NOT ${uri} MATCHES ":")
    lam_error("uri [${uri}] maybe not correct! expected: xxx:yyy")
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
      set(args ${args} GIT_TAG ${lam_pkg_tag})
      cpm_is_git_tag_commit_hash("${lam_pkg_tag}" IS_HASH)
      if (NOT ${IS_HASH})
        set(args ${args} GIT_SHALLOW ON)
      endif()
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

function(replace_abs_utility_to_rel var)
  string(REPLACE "${LAM_CMAKE_UTILITY_BASE_DIR}" "\${utility}" out "${${var}}")
  string(REPLACE "${LAM_CMAKE_UTILITY_BASE_DIR}" "\${utility}" __INSTALL_PREFIX "${LAM_PACKAGE_INSTALL_PREFIX}")
  string(REPLACE "${__INSTALL_PREFIX}" "\${install_prefix}" out "${out}")
  set(${var} ${out} PARENT_SCOPE)
endfunction()

function(lam_save_args out_path)
  string(REPLACE ";" "\n" pretty_content "${ARGN}")
  replace_abs_utility_to_rel(pretty_content)
  file(WRITE ${out_path} ${pretty_content})
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

  set(PKG_CPM_ARGS
    EXCLUDE_FROM_ALL YES
    NAME ${PKG_NAME}
    ${extra_args}
    ${patch_cmd}
    ${PKG_UNPARSED_ARGUMENTS}
    OPTIONS ${OPTIONS}
  )
  CPMAddPackage(${PKG_CPM_ARGS})
  # Save configs in ${PKG_NAME}_SOURCE_DIR
  lam_save_args(
    ${${PKG_NAME}_SOURCE_DIR}/../${PKG_NAME}.cpm_args
    ${PKG_CPM_ARGS}
  )
  # TODO: Enable Fetch latest tag without cloning.
  if (LAM_PACKAGE_FETCH_LATEST_TAG)
    execute_process(
      COMMAND git tag --sort=-creatordate
      OUTPUT_VARIABLE tags
      WORKING_DIRECTORY ${${PKG_NAME}_SOURCE_DIR}
    )
    string(REPLACE "\n" ";" tags "${tags}")
    if (NOT "${tags}" STREQUAL "")
      list(GET tags 0 tags)
    endif()
    message(WARNING "[package]: ${PKG_NAME}(${extra_args}): ${tags}")
  endif()

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
  if (DEFINED __pkg)
    lam_debug("NOTE: {__pkg}(${__pkg}) now would be override.")
  endif()
  string(TOLOWER ${pkg} __pkg)
  if (EXISTS ${USER_CUSTOM_PACKAGES_DIR}/pkg_${__pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/pkg_${__pkg}.cmake)
  elseif(${USER_CUSTOM_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
  elseif (EXISTS ${LAM_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${__pkg}.cmake)
    include(${LAM_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${__pkg}.cmake)
  elseif(EXISTS ${LAM_CMAKE_UTILITY_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
    include(${LAM_CMAKE_UTILITY_PACKAGES_DIR}/${__pkg}/pkg_${__pkg}.cmake)
  else()
    message(WARNING "package: ${pkg} not found. please provide `pkg_${__pkg}.cmake` to {USER_CUSTOM_PACKAGE_DIR}")
  endif()
  unset(__pkg)
endmacro()

# parse declare_deps format
# [~][!]name[#tag][@version]
# ~ indicate indicate the package is optional.
# '!' indicate whether use prebuilt mode.
# tag used to define name_TAG.
# version used to define name_VERSION.
function(lam_parse_deps_format uri out_name)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)

  string(REGEX REPLACE "^(~)?(!+)?([^@#!]+)" "" tag_version ${uri})
  set(pkg_name ${CMAKE_MATCH_3})
  set(optional_flag ${CMAKE_MATCH_1})
  set(prebuilt_flag ${CMAKE_MATCH_2})
  # NOTE: change the pkg_name to lower-case.
  string(TOLOWER ${pkg_name} pkg_name)
  string(REPLACE "~" "YES" optional_flag "${optional_flag}")
  if ("${prebuilt_flag}" STREQUAL "")
    unset(prebuilt_flag)
  elseif("${prebuilt_flag}" STREQUAL "!")
    set(prebuilt_flag YES)
  else()
    set(prebuilt_flag NO)
  endif()

  lam_debug("name: ${pkg_name}")
  lam_debug("optional: ${optional_flag}")
  lam_debug("prebuilt: ${prebuilt_flag}")
  lam_debug("tagversion: ${tag_version}")

  lam_assert_not_defined(pkg_tag pkg_version)
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
  set(${pkg_name}_USE_PREBUILT ${prebuilt_flag} PARENT_SCOPE)
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
    lam_pkg_status("current dep: ${dep}")
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
    if (DEFINED ${PKG}_VERSION)
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
  # flags to mark the overridded find_package.
  if (NOT _LAM_PACKAGE_OVERRIDED_FIND_PACKAGE)
    macro(find_package PKG)
      _find_package(${PKG} ${ARGN})
      verbose_find_package(${PKG})
    endmacro()
  endif()
  set(_LAM_PACKAGE_OVERRIDED_FIND_PACKAGE ON)
endif()

macro(find_package_ext PKG)
  find_package(${PKG} ${ARGN})
  if (NOT LAM_PACKAGE_OVERRIDE_FIND_PACKAGE)
    verbose_find_package(${PKG})
  endif()
endmacro()

# NOTE!! Only Experimentally support!!
# The external package should provide an install target.
# and has a well-designed install and then find strategy.
# Be aware to use this, only for advance user.
# Only for some well known package.
# FIND_PACKAGE_ARGS used to transfer args to Find_package.
# NOT_REQUIRED
#
# NOTE: find_package would define some variables,
# so change function to macro.
function(lam_parse_name_from_args out_name)
  cmake_parse_arguments(PKG "" "NAME" "" "${ARGN}")
  if (NOT DEFINED PKG_NAME)
    set(uri ${PKG_UNPARSED_ARGUMENTS})
    list(FILTER uri INCLUDE REGEX "^([^#: ]+):([^#@ ]+)(@[0-9.]*)?(#[^#@ ]*)?(@[0-9.]*)?$")
    list(LENGTH uri NUM_URI)
    lam_assert_list_size_var(uri 1)
    lam_get_name_from_uri(PKG_NAME ${uri})
  endif()
  lam_assert_defined(PKG_NAME)
  set(${out_name} ${PKG_NAME} PARENT_SCOPE)
endfunction()

function(lam_extract_cpm_and_find_args
    out_PKG_NAME
    out_PKG_CPM_ARGS
    out_PKG_CMAKE_ARGS
    out_PKG_FIND_ARGS
    out_PKG_NOT_REQUIRED
    out_PKG_INSTALL_PREFIX
  )
  # 1. split ARGN to CPM_ARGS, FIND_ARGS, and NOT_REQUIRED/REQUIRED flags.
  cmake_parse_arguments(PKG "NOT_REQUIRED;REQUIRED" "" "CPM_ARGS;FIND_ARGS" "${ARGN}")
  set(PKG_CPM_ARGS ${PKG_CPM_ARGS} ${PKG_UNPARSED_ARGUMENTS})

  # 2. get package name.
  lam_parse_name_from_args(PKG_NAME ${PKG_CPM_ARGS})
  cmake_parse_arguments(CPM_ARGS "" "NAME" "OPTIONS;CMAKE_ARGS" "${PKG_CPM_ARGS}")
  set(CPM_ARGS_NAME ${PKG_NAME})
  lam_assert_defined(CPM_ARGS_NAME)

  # transform options to cmake_args.
  foreach(arg ${CPM_ARGS_OPTIONS})
    cpm_parse_option("${arg}")
    list(APPEND CPM_ARGS_CMAKE_ARGS "-D${OPTION_KEY}=${OPTION_VALUE}")
  endforeach()

  # prepare cpm_args.
  set(PKG_CPM_ARGS
    ${CPM_ARGS_UNPARSED_ARGUMENTS}
    NAME ${CPM_ARGS_NAME}
    CMAKE_ARGS ${CPM_ARGS_CMAKE_ARGS}
  )

  # 3. prepare pkg_install_prefix.
  set(my_origin_parameters ${PKG_CPM_ARGS})
  replace_abs_utility_to_rel(my_origin_parameters)
  list(SORT my_origin_parameters)
  string(SHA1 my_origin_hash "${my_origin_parameters}")
  string(SUBSTRING "${my_origin_hash}" 0 8 my_origin_hash)
  set(PKG_INSTALL_PREFIX ${LAM_PACKAGE_INSTALL_PREFIX}/${CPM_ARGS_NAME}-${my_origin_hash})
  # save PKG_CPM_ARGS in ${LAM_PACKAGE_INSTALL_PREFIX}/${CPM_ARGS_NAME}-${my_origin_hash}
  lam_save_args(
    ${LAM_PACKAGE_INSTALL_PREFIX}/${CPM_ARGS_NAME}-${my_origin_hash}/cpm_args
    "${PKG_CPM_ARGS}"
  )

  # 4. output some args.
  set(${out_PKG_NAME} ${CPM_ARGS_NAME} PARENT_SCOPE)
  set(${out_PKG_CPM_ARGS} ${PKG_CPM_ARGS} PARENT_SCOPE)
  set(${out_PKG_CMAKE_ARGS} ${CPM_ARGS_CMAKE_ARGS} PARENT_SCOPE)
  set(${out_PKG_FIND_ARGS} ${PKG_FIND_ARGS} PARENT_SCOPE)
  set(${out_PKG_NOT_REQUIRED} ${PKG_NOT_REQUIRED} PARENT_SCOPE)
  set(${out_PKG_INSTALL_PREFIX} ${PKG_INSTALL_PREFIX} PARENT_SCOPE)
endfunction()

macro(__lam_unset_prebuilt_variables)
  lam_pop_variable(PKG_NAME)
  lam_pop_variable(PKG_CPM_ARGS)
  lam_pop_variable(PKG_CMAKE_ARGS)
  lam_pop_variable(PKG_FIND_ARGS)
  lam_pop_variable(PKG_NOT_REQUIRED)
  lam_pop_variable(PKG_INSTALL_PREFIX)
  lam_pop_variable(_EXTRA_FIND_ARGS)
endmacro()

macro(lam_add_prebuilt_package)
  lam_extract_cpm_and_find_args(
    _PKG_NAME
    _PKG_CPM_ARGS
    _PKG_CMAKE_ARGS
    _PKG_FIND_ARGS
    _PKG_NOT_REQUIRED
    _PKG_INSTALL_PREFIX
    "${ARGN}"
  )
  lam_assert_defined(_PKG_NAME _PKG_NOT_REQUIRED _PKG_INSTALL_PREFIX)
  lam_pkg_status("${_PKG_NAME} use prebuilt-mode.")

  lam_push_variable(PKG_NAME "${_PKG_NAME}")
  lam_push_variable(PKG_CPM_ARGS "${_PKG_CPM_ARGS}")
  lam_push_variable(PKG_CMAKE_ARGS "${_PKG_CMAKE_ARGS}")
  lam_push_variable(PKG_FIND_ARGS "${_PKG_FIND_ARGS}")
  lam_push_variable(PKG_NOT_REQUIRED "${_PKG_NOT_REQUIRED}")
  lam_push_variable(PKG_INSTALL_PREFIX "${_PKG_INSTALL_PREFIX}")
  unset(_PKG_NAME)
  unset(_PKG_CPM_ARGS)
  unset(_PKG_CMAKE_ARGS)
  unset(_PKG_FIND_ARGS)
  unset(_PKG_NOT_REQUIRED)
  unset(_PKG_INSTALL_PREFIX)

  # set find_package extra args.
  lam_push_variable(_EXTRA_FIND_ARGS "PATHS;${PKG_INSTALL_PREFIX}")
  # lam_push_variable(CMAKE_PREFIX_PATH "${PKG_INSTALL_PREFIX}")
  if (NOT LAM_PACKAGE_ENABLE_DEFAULT_SEARCH_PATH)
    list(APPEND _EXTRA_FIND_ARGS NO_DEFAULT_PATH)
  endif()

  if (LAM_PACKAGE_ENABLE_TRY_FIND)
    find_package_ext(${PKG_NAME} ${PKG_FIND_ARGS}
      ${_EXTRA_FIND_ARGS}
    )
  endif()

  if (${PKG_NAME}_FOUND OR PKG_NOT_REQUIRED)
  else()
    if (NOT PKG_NOT_REQUIRED)
      # check whether the package is REQUIRED.
      # If this package is not required, return and does not need to download.
      list(APPEND _EXTRA_FIND_ARGS REQUIRED)
    endif()
    # download package by cpm.
    lam_download_package(${PKG_CPM_ARGS})
    lam_assert_defined(${PKG_NAME}_SOURCE_DIR)

    # configure package.
    execute_process(
      COMMAND ${CMAKE_COMMAND}
      -S ${${PKG_NAME}_SOURCE_DIR}
      -B${CMAKE_BINARY_DIR}/deps-build/${PKG_NAME}
      -G${CMAKE_GENERATOR}
      -DCMAKE_BUILD_TYPE=${LAM_PACKAGE_BUILD_TYPE}
      -DBUILD_SHARED_LIBS=${LAM_PACKAGE_BUILD_SHARED}
      -DCMAKE_POSITION_INDEPENDENT_CODE=${LAM_PACKAGE_BUILD_WITH_PIC}
      -DCMAKE_INSTALL_PREFIX=${PKG_INSTALL_PREFIX}
      -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
      -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
      ${PKG_CMAKE_ARGS}
      WORKING_DIRECTORY ${${PKG_NAME}_SOURCE_DIR}
      OUTPUT_QUIET
      RESULT_VARIABLE result
    )
    if (result)
      lam_fatal("[cmake/package] configure external project(${PKG_NAME}) failed: ${result}")
    endif()

    if (NOT LAM_PACKAGE_VERBOSE_INSTALL)
      set(__ARGS OUTPUT_QUIET)
    endif()

    # install package.
    execute_process(
      COMMAND ${CMAKE_COMMAND}
      --build ${CMAKE_BINARY_DIR}/deps-build/${PKG_NAME} --target install -j ${LAM_PACKAGE_NUM_THREADS}
      RESULT_VARIABLE result
      ${__ARGS}
    )

    if (result)
      lam_fatal("[cmake/package] Failed to install external package(${PKG_NAME}): ${result}")
    endif()
    unset(__ARGS)
    unset(result)

    # find package again.
    find_package_ext(${PKG_NAME} ${PKG_FIND_ARGS}
      ${_EXTRA_FIND_ARGS}
    )
  endif()
  __lam_unset_prebuilt_variables()
  # lam_pop_variable(CMAKE_PREFIX_PATH)
endmacro()

########################################################################
# define some alias
########################################################################
function(lam_check_prefer_prebuilt out name)
  # If defined ${name}_USE_PREBUILT and it's ON.
  # or does not defined ${name}_USE_PREBUILT
  # but the global flags LAM_PACKAGE_PREFER_PREBUILT is ON
  if (DEFINED ${name}_USE_PREBUILT)
    set(USE_PREBUILT_FLAG ${${name}_USE_PREBUILT})
  elseif(DEFINED __pkg AND DEFINED ${__pkg}_USE_PREBUILT)
    set(USE_PREBUILT_FLAG ${${__pkg}_USE_PREBUILT})
  else()
    # default prebuilt-flag.
    set(USE_PREBUILT_FLAG ${LAM_PACKAGE_PREFER_PREBUILT})
  endif()
  set(${out} ${USE_PREBUILT_FLAG} PARENT_SCOPE)
endfunction()

macro(lam_add_package_maybe_prebuilt dep_name) # args.
  lam_check_prefer_prebuilt(prebuilt_flag ${dep_name})
  if (prebuilt_flag)
    lam_add_prebuilt_package(${ARGN})
  else()
    lam_add_package(${ARGN})
  endif()
  unset(prebuilt_flag)
endmacro()
