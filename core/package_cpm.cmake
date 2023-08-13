include_guard()

use_cmake_core_module(assert)
register_cmake_module_path(packages)

# Use CPM.cmake instead.
if (NOT DEFINED ENV{CPM_SOURCE_CACHE})
  set(ENV{CPM_SOURCE_CACHE} ${CMAKE_SOURCE_DIR}/external)
endif()

set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

########################################################################
# Options/CacheVariables
########################################################################
option(CHAOS_PACKAGE_OVERRIDE_FIND_PACKAGE "override find_package with verbose" ON)
option(CHAOS_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." OFF)
option(CHAOS_PACKAGE_VERBOSE_INSTALL "Enable verbose ExternalPackage" ON)

message(DEBUG "[package_cpm|TRY_FIND]: ${CHAOS_PACKAGE_ENABLE_TRY_FIND}")
set(CHAOS_PACKAGE_BUILD_TYPE ${CMAKE_BUILD_TYPE}
  CACHE STRING "Default ExternalPackage BuildType"
)
if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CHAOS_PACKAGE_BUILD_TYPE "Release")
endif()
# BuildType to lowercase.
string(TOLOWER ${CHAOS_PACKAGE_BUILD_TYPE} CHAOS_PACKAGE_BUILD_TYPE_LC)
message(DEBUG "[package_cpm|ExternalProjectBuildType]: ${CHAOS_PACKAGE_BUILD_TYPE}")

set(CHAOS_PACKAGE_INSTALL_PREFIX ${CPM_SOURCE_CACHE}/installed/${CHAOS_PACKAGE_BUILD_TYPE_LC}
  CACHE PATH "Directory to install external package."
)
message(DEBUG "[package_cpm|ExternalPackageInstallPath]: ${CHAOS_PACKAGE_INSTALL_PREFIX}")

set(CHAOS_PACKAGE_NUM_THREADS 0 CACHE STRING "Number of Threads used to comile.")
if (${CHAOS_PACKAGE_NUM_THREADS} EQUAL 0)
  include(ProcessorCount)
  ProcessorCount(CHAOS_PACKAGE_NUM_THREADS)
endif()
message(STATUS "[package#Threads]: ${CHAOS_PACKAGE_NUM_THREADS}")

########################################################################
# Core Implementation.
########################################################################
function(is_version out v)
  message(DEBUG "check whether |${v}| is version")

  # major[.minor[.patch[.tweak]]]
  string(REGEX MATCH "^[0-9]+(.[0-9]+)?(.[0-9]+)?(.[0-9]+)?$" res ${v})

  if(res)
    set(${out} YES PARENT_SCOPE)
  else()
    set(${out} NO PARENT_SCOPE)
  endif()
endfunction()

function(infer_package_name_from_uri out uri)
  # trim tailing.
  DEBUG_MSG("infer_package_name_from ${uri}")

  string(REGEX REPLACE "@([0-9.]*)$" "" uri ${uri})
  string(REGEX REPLACE "#(.*)$" "" uri ${uri})
  string(REGEX REPLACE ".git$" "" uri ${uri})
  DEBUG_MSG("uri after trim: ${uri}")

  if (${uri} MATCHES "([^/:]+)$")
    set(${out} ${CMAKE_MATCH_1} PARENT_SCOPE)
  else()
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

function(infer_version_from_tag out tag)
  message(DEBUG "infer_version_from ${tag}")

  # extract version pattern from tag.
  if(${tag} MATCHES "^[^0-9]*([0-9]+[0-9.]*)([^0-9]+.*)*$")
    is_version(_ ${CMAKE_MATCH_1})

    if(_)
      message(DEBUG "infer_version_from_tag get: ${CMAKE_MATCH_1}")
      set(${out} ${CMAKE_MATCH_1} PARENT_SCOPE)
    else()
      unset(${out} PARENT_SCOPE)
    endif()
  else()
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

# uri must be: scheme:path[#tag][@version]
function(infer_args_from_uri out_args uri)
  message(DEBUG "infer_args_from_uri: input is |${uri}|")
  # Step0. check uri.
  if (${uri} MATCHES " ")
    message(FATAL_ERROR "uri |${uri}| cannot has SPACE")
  elseif(${uri} MATCHES "#[^#]*#")
    message(FATAL_ERROR "uri |${uri}| cannot has more than 1 '#'")
  endif()

  # Step1. pick tailing version.
  if (${uri} MATCHES "@([0-9.]*)$")
    set(version "${CMAKE_MATCH_1}")
    string(REGEX REPLACE "@([0-9.]*)$" "" uri ${uri})
  endif()
  # Step2. pick tailing tag.
  if (${uri} MATCHES "#(.*)$")
    set(tag ${CMAKE_MATCH_1})
    # if version is empty. just simply skip it, do not infer from tag.
    if (NOT DEFINED version)
      infer_version_from_tag(version ${tag})
    endif()
    string(REGEX REPLACE "#(.*)$" "" url ${uri})
  endif()
  message(DEBUG "tag is: ${tag}, version is: ${version}")
  # Step3. pick scheme.
  # infer scheme from url.
  # scheme:path
  if(${url} MATCHES "^([^:]+):(.+)$")
    string(TOLOWER ${CMAKE_MATCH_1} scheme)
    set(path ${CMAKE_MATCH_2})
    DEBUG_MSG("Current.Match.Scheme: ${scheme}")
    DEBUG_MSG("Current.Match.Path: ${path}")
  endif()

  # some special schemes
  if(scheme STREQUAL "rom") # ryon.ren:mirrors
    if(${path} MATCHES "([^/]+)$") # infer repo.name
      set(out GIT_REPOSITORY
        ssh://git@ryon.ren:10022/mirrors/${CMAKE_MATCH_1})
    else()
      ERROR_MSG("Unable to infer repo name: ${path}")
    endif()

    set(type git)
  elseif(scheme STREQUAL "gh") # github
    set(out GIT_REPOSITORY https://github.com/${path})
    set(type git)
  elseif(scheme STREQUAL "gl") # gitlab
    set(out GIT_REPOSITORY https://gitlab.com/${path})
    set(type git)
  elseif(scheme STREQUAL "bb") # bitbucket
    set(out GIT_REPOSITORY https://bitbucket.org/${path})
    set(type git)
  else() # normal test.
    # FIXME: Too Ugly!!!
    if(${url} MATCHES ".*\\.git$" # end with **.git**
      OR ${url} MATCHES "^(ssh://)?git@" # start with [ssh://]git@

      # https://github/gitlab.com/Username/RepoName
      OR ${url} MATCHES "^https://github\\.com/[^/ ]+/[^/ ]+$"
      OR ${url} MATCHES "^https://gitlab\\.com/[^/ ]+/[^/ ]+$"
      OR ${url} MATCHES "^https://funannongwu\\.com/[^/ ]+/[^/ ]+$"

      # https://ryon.ren
      OR ${url} MATCHES "^https://ryon\\.ren:2443/[^/ ]+/[^/ ]+$"

      # https://bitbucket.org
      OR ${url} MATCHES "^https://bitbucket\\.org/[^/ ]+/[^/ ]+$"
    )
      set(out GIT_REPOSITORY ${url})
      set(type git)
    else() # FIXME: other protocol: svn. cvs
      set(out URL ${url})
    endif()
  endif()

  if(NOT ${tag} STREQUAL "")
    if(${type} STREQUAL git)
      set(out ${out} GIT_TAG ${tag})
    else()
      set(out ${out} URL_HASH ${tag})
    endif()
  endif()

  if (DEFINED version)
    set(out ${out} VERSION "${version}")
  endif()

  message("Current.Prepare.args: ${out}")

  set(${out_args} ${out} PARENT_SCOPE)
endfunction()

macro(require_package uri)
  DEBUG_MSG("uri: ${uri}")
  DEBUG_MSG("args: ${ARGN}")
  # extract uri from args.
  infer_args_from_uri(extra_args "${uri}")
  DEBUG_MSG("extra_args: ${extra_args}")

  # parse CMAKE_ARGS/GIT_PATCH
  cmake_parse_arguments(PKG "" "GIT_PATCH;NAME;DOWNLOAD_ONLY" "CMAKE_ARGS" "${ARGN}")

  # parse Name.
  if (NOT DEFINED PKG_NAME)
    infer_package_name_from_uri(PKG_NAME ${uri})
  endif()
  list(APPEND extra_args NAME ${PKG_NAME})
  if (DEFINED PKG_DOWNLOAD_ONLY)
    list(APPEND extra_args DOWNLOAD_ONLY ${PKG_DOWNLOAD_ONLY})
  endif()

  set(CPM_OPTIONS "")
  foreach(arg ${PKG_CMAKE_ARGS})
    if(${arg} MATCHES "^-D([^ ]+)(:[^ ]+)?=([^ ]+)$")
      DEBUG_MSG("Key: ${CMAKE_MATCH_1}, Value: ${CMAKE_MATCH_3}, Type: ${CMAKE_MATCH_2}")
      set(CPM_OPTIONS ${CPM_OPTIONS} "${CMAKE_MATCH_1} ${CMAKE_MATCH_3}")
    else()
      ERROR_MSG("Unknown cmake_arg: ${arg}, should be specified as: -D<var>[:<type>]=<value>")
    endif()
  endforeach()

  DEBUG_MSG("CMAKE.ARGS: ${CPM_OPTIONS}")

  if (DEFINED PKG_GIT_PATCH)
    get_filename_component(PKG_GIT_PATCH ${PKG_GIT_PATCH} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    ASSERT_FILE_EXISTS(${PKG_GIT_PATCH})
    find_package(Git REQUIRED)
    ASSERT_DEFINED(GIT_EXECUTABLE)
    list(APPEND extra_args
      PATCH_COMMAND ${GIT_EXECUTABLE} restore . && ${GIT_EXECUTABLE} apply ${PKG_GIT_PATCH}
    )
  endif()

  CPMAddPackage(
    EXCLUDE_FROM_ALL YES
    ${extra_args}
    ${PKG_UNPARSED_ARGUMENTS}
    OPTIONS ${CPM_OPTIONS}
  )
  unset(CPM_OPTIONS)
  unset(extra_args)
endmacro()

macro(optional_package uri)
  infer_package_name_from_uri(pkg ${uri})
  string(TOUPPER ${pkg} PKG)
  if (NOT DEFINED OPTIONAL_PKG_PREFIX)
    if (CHAOS_USE_${PKG})
      require_package(${ARGV})
    endif()
  else()
    if (${OPTIONAL_PKG_PREFIX}_${PKG})
      require_package(${ARGV})
    endif()
  endif()
  unset(pkg)
endmacro()

macro(download_package uri)
  require_package(${ARGV} DOWNLOAD_ONLY YES)
endmacro()

macro(optional_download_package)
  optional_package(${ARGV} DOWNLOAD_ONLY YES)
endmacro()

# for register packages.
macro(include_package pkg)
  if (EXISTS ${USER_CUSTOM_PACKAGES_DIR}/pkg_${pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/pkg_${pkg}.cmake)
  elseif(${USER_CUSTOM_PACKAGES_DIR}/${pkg}/pkg_${pkg}.cmake)
    include(${USER_CUSTOM_PACKAGES_DIR}/${pkg}/pkg_${pkg}.cmake)
  elseif (EXISTS ${_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${pkg}.cmake)
    include(${_CMAKE_UTILITY_PACKAGES_DIR}/pkg_${pkg}.cmake)
  elseif(EXISTS ${_CMAKE_UTILITY_PACKAGES_DIR}/${pkg}/pkg_${pkg}.cmake)
    include(${_CMAKE_UTILITY_PACKAGES_DIR}/${pkg}/pkg_${pkg}.cmake)
  else()
    message(WARNING "package: ${pkg} not found. please provide `pkg_${pkg}.cmake` to {USER_CUSTOM_PACKAGE_DIR}")
  endif()
endmacro()

macro(declare_pkg_deps)
  foreach(dep ${ARGV})
    message(STATUS "Current dep: ${dep}")
    if (${dep} MATCHES "^([^@#]+)#([^#]+)$")
      # split dep into name#tag[@version]
      set(${CMAKE_MATCH_1}_TAG ${CMAKE_MATCH_2})
      message(STATUS "${CMAKE_MATCH_1} use ${CMAKE_MATCH_2}")
      include_package(${CMAKE_MATCH_1})
    elseif(${dep} MATCHES "^([^@#]+)@([0-9.]+)$")
      # split dep into name@version
      set(${CMAKE_MATCH_1}_VERSION ${CMAKE_MATCH_2})
      message(STATUS "${CMAKE_MATCH_1} use ${CMAKE_MATCH_2}")
      include_package(${CMAKE_MATCH_1})
    elseif(${dep} MATCHES "^([^@#]+)(@(default)?)?$")
      message(STATUS "${CMAKE_MATCH_1} use default")
      # use default tag.
      include_package(${CMAKE_MATCH_1})
    else()
      message(FATAL_ERROR "Invalid dep format(name[#tag][@version]): ${dep}")
    endif()
  endforeach()
endmacro()

macro(optional_pkg_deps)
  foreach(dep ${ARGV})
    if (${dep} MATCHES "^([^@#]*)")
      string(TOUPPER ${CMAKE_MATCH_1} PKG_NAME)
      if (NOT DEFINED OPTIONAL_PKG_PREFIX)
        if (CHAOS_USE_${PKG_NAME})
          declare_pkg_deps(${dep})
        endif()
      else()
        if (${OPTIONAL_PKG_PREFIX}_${PKG_NAME})
          declare_pkg_deps(${dep})
        endif()
      endif()
    else()
      message(FATAL_ERROR "Cannot infer package name: ${dep}")
    endif()
  endforeach()
endmacro()

macro(verbose_find_package PKG)
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
endmacro()

if (CHAOS_PACKAGE_OVERRIDE_FIND_PACKAGE)
  macro(find_package PKG)
    _find_package(${PKG} ${ARGN})
    verbose_find_package(${PKG})
  endmacro()
endif()

macro(find_package_ext PKG)
  find_package(${PKG} ${ARGN})
  if (NOT CHAOS_PACKAGE_OVERRIDE_FIND_PACKAGE)
    verbose_find_package(${PKG})
  endif()
endmacro()

# NOTE!! Only Experimentally support!!
macro(install_and_find_package)
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
    list(FILTER uri INCLUDE REGEX "^([^#: ]+):([^#@ ]+)(#[^#@ ]*)?(@[0-9.]*)?$")
    list(LENGTH uri NUM_URI)
    ASSERT_EQUAL(${NUM_URI} 1)
    infer_package_name_from_uri(CPM_ARGS_NAME ${uri})
  endif()
  foreach(arg ${CPM_ARGS_OPTIONS})
    cpm_parse_option("${arg}")
    list(APPEND CPM_ARGS_CMAKE_ARGS "-D${OPTION_KEY}=${OPTION_VALUE}")
  endforeach()

  if (CHAOS_PACKAGE_ENABLE_TRY_FIND)
    # TODO: use args-hashed to distinguish different prebuild.
    find_package(${CPM_ARGS_NAME} ${find_package_args} NO_DEFAULT_PATH
      PATHS ${CHAOS_PACKAGE_INSTALL_PREFIX}
    )
  endif()


  if (${${CPM_ARGS_NAME}_FOUND})
    # cannot use return(), since this is a macro instead of a function.
  else()
    # download package by cpm.
    download_package(${PKG_CPM_ARGS})

    execute_process(
      COMMAND ${CMAKE_COMMAND}
      -S ${${CPM_ARGS_NAME}_SOURCE_DIR}
      -B${CMAKE_BINARY_DIR}/deps-build/${CPM_ARGS_NAME}
      -G${CMAKE_GENERATOR}
      -DCMAKE_BUILD_TYPE=${CHAOS_PACKAGE_BUILD_TYPE}
      -DCMAKE_INSTALL_PREFIX=${CHAOS_PACKAGE_INSTALL_PREFIX}
      -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
      -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
      ${CPM_ARGS_CMAKE_ARGS}
      WORKING_DIRECTORY ${${CPM_ARGS_NAME}_SOURCE_DIR}
      OUTPUT_QUIET
      RESULT_VARIABLE result
    )
    if (result)
      message(FATAL_ERROR "configure external project(${CPM_ARGS_NAME}) failed: ${result}")
    endif()

    if (NOT CHAOS_PACKAGE_VERBOSE_INSTALL)
      set(__ARGS OUTPUT_QUIET)
    endif()

    execute_process(
      COMMAND ${CMAKE_COMMAND}
      --build ${CMAKE_BINARY_DIR}/deps-build/${CPM_ARGS_NAME} --target install -j ${CHAOS_PACKAGE_NUM_THREADS}
      RESULT_VARIABLE result
      ${__ARGS}
    )

    if (result)
      message(FATAL_ERROR "Failed to install external package: ${CPM_ARGS_NAME}")
    endif()

    find_package(${CPM_ARGS_NAME} ${find_package_args} NO_DEFAULT_PATH
      PATHS ${CHAOS_PACKAGE_INSTALL_PREFIX}
    )
  endif()
endmacro()
