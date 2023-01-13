include_guard()

# Point to the current source base dir.
# In order to locate `extproj.cmake.in`
set(_CORE_PACKAGE_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
include(${_CORE_PACKAGE_BASE_DIR}/cmake-core-assert.cmake)

# #######################################################################
# Options/CacheVariables
# #######################################################################
# SOURCE_DIR point to the RootProjDir.
set(EXT_PACKAGE_BASE_DIR ${CMAKE_SOURCE_DIR}/3rd
  CACHE PATH "The BaseDir for extPackage. extPackage will be download/clone to here.")
set(EXT_PACKAGE_BUILD_BASE_DIR ${CMAKE_BINARY_DIR}/3rd
  CACHE PATH "The BaseDir for extPackage building. extPackage included as subdirectory will be build here.")
set(EXT_PACKAGE_BUILD_TYPE "release" CACHE STRING "Default extPackage BuildType[lowercase].")
option(EXT_PACKAGE_LOCAL_ONLY "use find_package only." OFF)
option(EXT_PACKAGE_LOCAL_FIRST "use find_package first." ON)
option(EXT_PACKAGE_DOWNLOAD_ONLY "download extPackage only." OFF)
option(EXT_PACKAGE_REGISTER_SEARCH_PATH "Add extPackage Path to CMAKE_MODULE/PREFIX_PATH" ON)

# #######################################################################
# variable/options check.
# #######################################################################
# Disable Some Invalid Base.Dir
if(EXT_PACKAGE_BASE_DIR STREQUAL CMAKE_SOURCE_DIR)
  ERROR_MSG("In-source ExternalCache is not allowed! Please set `EXT_PACKAGE_BASE_DIR` to another dir. <Default>: ${CMAKE_SOURCE_DIR}/3rd")
endif()

# build_type to lower.
string(TOLOWER ${EXT_PACKAGE_BUILD_TYPE} EXT_PACKAGE_BUILD_TYPE)

if(EXT_PACKAGE_REGISTER_SEARCH_PATH)
  list(PREPEND CMAKE_MODULE_PATH ${EXT_PACKAGE_BASE_DIR}/install/${EXT_PACKAGE_BUILD_TYPE})
  list(PREPEND CMAKE_PREFIX_PATH ${EXT_PACKAGE_BASE_DIR}/install/${EXT_PACKAGE_BUILD_TYPE})
endif()

# #######################################################################
# Core Implementation.
# #######################################################################
# find_package(<PackageName> [version] [EXACT] [QUIET]
# [REQUIRED] [[COMPONENTS] [components...]]
# [OPTIONAL_COMPONENTS components...]
# [CONFIG|NO_MODULE]
# [GLOBAL]
# [NO_POLICY_SCOPE]
# [BYPASS_PROVIDER]
# [NAMES name1 [name2 ...]]
# [CONFIGS config1 [config2 ...]]
# [HINTS path1 [path2 ... ]]
# [PATHS path1 [path2 ... ]]
# [REGISTRY_VIEW  (64|32|64_32|32_64|HOST|TARGET|BOTH)]
# [PATH_SUFFIXES suffix1 [suffix2 ...]]
# [NO_DEFAULT_PATH]
# [NO_PACKAGE_ROOT_PATH]
# [NO_CMAKE_PATH]
# [NO_CMAKE_ENVIRONMENT_PATH]
# [NO_SYSTEM_ENVIRONMENT_PATH]
# [NO_CMAKE_PACKAGE_REGISTRY]
# [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
# [NO_CMAKE_SYSTEM_PATH]
# [NO_CMAKE_INSTALL_PREFIX]
# [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
# [CMAKE_FIND_ROOT_PATH_BOTH |
# ONLY_CMAKE_FIND_ROOT_PATH |
# NO_CMAKE_FIND_ROOT_PATH])
#
# default, require_package is set to REQUIRED.
#
# FIXME: some package will setup some variable and need to popup.
# like catch2, it will setup MODULE_PATH for include(Catch)
# Thus, use macro instead.
macro(ep_find_package PKG) # ensure that argn has been prepared for find_package.
  find_package(${PKG} ${ARGN})

  # verbose some infos.
  if(${PKG}_FOUND)
    set(PKG_FOUND TRUE)
    set(PKG_VERSION ${${PKG}_VERSION})
    string(TOUPPER ${PKG} tmp)
    message(STATUS "[package/${PKG}]: find version: ${PKG_VERSION}")

    if(${tmp}_INCLUDE_DIR)
      message(STATUS "[package/${PKG}]: include_dir: ${${tmp}_INCLUDE_DIR}")
    elseif(${tmp}_INCLUDE_DIRS)
      message(STATUS "[package/${PKG}]: include_dir: ${${tmp}_INCLUDE_DIRS}")
    endif()
  else()
    set(PKG_FOUND FALSE)
  endif()
endmacro()

# use function here to avoid populating options/variable.
# ep_add_subdirectory(source_dir binary_dir [EXCLUDE_FROM_ALL] [CMAKE_ARGS ...])
function(ep_add_subdirectory SOURCE_DIR BINARY_DIR)
  get_filename_component(SOURCE_DIR ${SOURCE_DIR} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
  ASSERT_PATH_EXISTS(${SOURCE_DIR})
  ASSERT_FILE_EXISTS(${SOURCE_DIR}/CMakeLists.txt)
  cmake_parse_arguments(ARGS "EXCLUDE_FROM_ALL" "" "CMAKE_ARGS" ${ARGN})

  set(subdir_args ${SOURCE_DIR} ${BINARY_DIR})

  if(ARGS_EXCLUDE_FROM_ALL)
    set(subdir_args ${subdir_args} EXCLUDE_FROM_ALL)
  endif()

  DEBUG_MSG("subdir_args: ${subdir_args}")

  foreach(option ${ARGS_CMAKE_ARGS})
    if(${option} MATCHES "^-D([^ ]*)=([^ ]*)$")
      DEBUG_MSG("KEY: ${CMAKE_MATCH_1}, VALUE: ${CMAKE_MATCH_2}")
      set(${CMAKE_MATCH_1} ${CMAKE_MATCH_2})
    else()
      DEBUG_MSG("UNKNOWN CMAKE_ARGS: ${option}")
    endif()
  endforeach()

  add_subdirectory(${subdir_args})
endfunction()

macro(get_ep_config_dir out name args PREFIX)
  ASSERT_EQUAL(${ARGC} 4)
  string(SHA1 hash_args "${args}")
  string(SUBSTRING "${hash_args}" 0 8 hash_args)
  set(${out} ${PREFIX}/.cache/.ep_config/${name}-${hash_args})
endmacro()

macro(get_ep_install_dir out name args BUILD_TYPE PREFIX)
  ASSERT_EQUAL(${ARGC} 5)
  string(SHA1 hash_args "${args}")
  string(SUBSTRING "${hash_args}" 0 8 hash_args)
  set(${out} ${PREFIX}/install/${BUILD_TYPE}/${name}-${hash_args})
endmacro()

macro(get_ep_source_dir out name PREFIX)
  ASSERT_EQUAL(${ARGC} 3)
  set(${out} ${PREFIX}/${name})
endmacro()

function(check_cmake_args args)
  ASSERT_EQUAL(${ARGC} 1)

  foreach(arg ${args})
    if(${arg} MATCHES "^-D([^ ]+)(:[^ ]+)?=([^ ]+)$")
      DEBUG_MSG("Key: ${CMAKE_MATCH_1}, Value: ${CMAKE_MATCH_3}, Type: ${CMAKE_MATCH_2}")
    else()
      ERROR_MSG("Unknown cmake_arg: ${arg}, should be specified as: -D<var>[:<type>]=<value>")
    endif()
  endforeach()
endfunction()

set(DO_NOTHING_CMD "${CMAKE_COMMAND} -E echo do nothing.")

# https://cmake.org/cmake/help/latest/module/ExternalProject.html
function(ep_configure_package name)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}.ARGV: ${ARGV}")
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}.ARGC: ${ARGC}")
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}.ARGN: ${ARGN}")

  set(options BUILD_STATIC OFF_GIT_SHALLOW
    DOWNLOAD_ONLY
    OUT_SOURCE_DIR OUT_INSTALL_DIR OUT_CONFIG_DIR)
  set(oneValueArgs PREFIX BUILD_TYPE
    GIT_SHALLOW
    GIT_PATCH # easy apply git patch.
    TMP_DIR STAMP_DIR LOG_DIR BINARY_DIR # do not allow to set.
    DOWNLOAD_DIR SOURCE_DIR INSTALL_DIR
  )
  set(multiValueArgs STEP_TARGETS CMAKE_ARGS)
  cmake_parse_arguments(EP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # do not allow pass more args.
  # ASSERT_EMPTY(EP_UNPARSED_ARGUMENTS)
  ASSERT_NOT_DEFINED(EP_TMP_DIR EP_STAMP_DIR EP_LOG_DIR EP_BINARY_DIR EP_STEP_TARGETS)
  check_cmake_args("${EP_CMAKE_ARGS}")

  # prepare args.
  if(EP_OFF_GIT_SHALLOW AND(DEFINED EP_GIT_SHALLOW))
    ERROR_MSG("Cannot both specify OFF_GIT_SHALLOW and GIT_SHALLOW at the same time.")
  endif()

  if((NOT EP_OFF_GIT_SHALLOW) AND(NOT DEFINED EP_GIT_SHALLOW))
    list(APPEND EP_UNPARSED_ARGUMENTS GIT_SHALLOW ON)
  elseif(DEFINED EP_GIT_SHALLOW)
    list(APPEND EP_UNPARSED_ARGUMENTS GIT_SHALLOW ${EP_GIT_SHALLOW})
  endif()

  set(EP_NAME ${name})

  if(NOT DEFINED EP_BUILD_TYPE)
    set(EP_BUILD_TYPE ${EXT_PACKAGE_BUILD_TYPE})
  endif()

  if(NOT DEFINED EP_PREFIX)
    set(EP_PREFIX ${EXT_PACKAGE_BASE_DIR})
  endif()

  if(EXISTS ${EP_PREFIX})
    ASSERT_PATH_EXISTS(${EP_PREFIX})
    get_filename_component(EP_PREFIX ${EP_PREFIX} ABSOLUTE)
  endif()

  # TODO. set config dir.
  get_ep_config_dir(EP_CONFIG_DIR ${name} "${EP_CMAKE_ARGS}" ${EP_PREFIX})
  set(EP_TMP_DIR ${EP_CONFIG_DIR}/tmp)
  set(EP_STAMP_DIR ${EP_CONFIG_DIR}/stamp)
  set(EP_LOG_DIR ${EP_CONFIG_DIR}/log)

  if((NOT DEFINED EP_DOWNLOAD_DIR) AND(NOT DEFINED EP_SOURCE_DIR))
    get_ep_source_dir(EP_SOURCE_DIR ${name} ${EP_PREFIX})
  elseif(NOT DEFINED EP_SOURCE_DIR)
    set(EP_SOURCE_DIR ${EP_DOWNLOAD_DIR})
  endif()

  set(EP_BINARY_DIR ${EP_CONFIG_DIR}/build-${EP_BUILD_TYPE})

  if(NOT DEFINED EP_INSTALL_DIR)
    get_ep_install_dir(EP_INSTALL_DIR ${name} "${EP_CMAKE_ARGS}" ${EP_BUILD_TYPE} ${EP_PREFIX})
  endif()

  set(EP_STEP_TARGETS update patch build install)
  set(EP_ARGS ${EP_UNPARSED_ARGUMENTS} CMAKE_ARGS ${EP_CMAKE_ARGS})

  if(EP_DOWNLOAD_ONLY OR EXT_PACKAGE_DOWNLOAD_ONLY)
    list(PREPEND EP_ARGS
      CONFIGURE_COMMAND ${DO_NOTHING_CMD}
      BUILD_COMMAND ${DO_NOTHING_CMD}
      TEST_COMMAND ${DO_NOTHING_CMD}
      INSTALL_COMMAND ${DO_NOTHING_CMD})
  endif()

  # apply git patch.
  if(DEFINED EP_GIT_PATCH)
    ASSERT_FILE_EXISTS(${EP_GIT_PATCH})
    find_package(Git REQUIRED)
    ASSERT_DEFINED(GIT_EXECUTABLE)
    list(PREPEND EP_ARGS
      PATCH_COMMAND "${GIT_EXECUTABLE} restore . && ${GIT_EXECUTABLE} apply ${EP_GIT_PATCH}")
  endif()

  if(NOT EP_BUILD_STATIC)
    # https://cmake.org/cmake/help/latest/prop_tgt/POSITION_INDEPENDENT_CODE.html
    # flags **-fPIC** will be automatically set.
    list(APPEND EP_ARGS CMAKE_ARGS "-DBUILD_SHARED_LIBS=ON")
  endif()

  # configure the extproj.
  configure_file(${_CORE_PACKAGE_BASE_DIR}/extproj.cmake.in ${EP_CONFIG_DIR}/CMakeLists.txt @ONLY)

  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -G ${CMAKE_GENERATOR}
    -S ${EP_CONFIG_DIR}
    -B ${EP_TMP_DIR}/build
    RESULT_VARIABLE result
    OUTPUT_QUIET
    WORKING_DIRECTORY ${EP_CONFIG_DIR}
  )

  if(result)
    ERROR_MSG("Configure ExternalProject(${EP_NAME}) Failed: ${result}")
  endif()

  # TODO. maybe it is better to register these in some list.
  foreach(DIR SOURCE INSTALL CONFIG)
    if(EP_OUT_${DIR}_DIR)
      set(EP_${DIR}_DIR ${EP_${DIR}_DIR} PARENT_SCOPE)
    endif()
  endforeach()
endfunction()

function(run_command cmd work_dir)
  ASSERT_PATH_EXISTS(${work_dir})
  message("-- Run: ${cmd}")
  execute_process(
    COMMAND ${cmd}
    RESULT_VARIABLE result
    OUTPUT_QUIET
    WORKING_DIRECTORY ${work_dir})

  if(result)
    ERROR_MSG("Run CMD(${cmd}) Failed: ${result}")
  endif()
endfunction()

function(ep_prepare_command cmd config_dir)
  DEBUG_MSG("${CMAKE_CURRENT_FUNCTION}.ARGV: ${ARGV}")
  ASSERT_PATH_EXISTS(${config_dir})

  if(ARGN)
    set(tgt --target ${ARGN})
  endif()

  set(${cmd} ${CMAKE_COMMAND} --build ${config_dir}/tmp/build -j12 ${tgt} PARENT_SCOPE)
endfunction()

macro(ep_fetch_command cmd name config_dir)
  ep_prepare_command(${cmd} ${config_dir} ${name}-patch)
endmacro()

macro(ep_build_command cmd name config_dir)
  ep_prepare_command(${cmd} ${config_dir} ${name}-build)
endmacro()

macro(ep_install_command cmd name config_dir)
  ep_prepare_command(${cmd} ${config_dir} ${name}-install)
endmacro()

# more than 2 arguments will defer by default.
function(fetch_package name config_dir)
  ep_fetch_command(cmd ${name} ${config_dir})

  if(${ARGC} EQUAL 2)
    run_command(
      "${cmd}"
      ${config_dir})
  endif()

  if(NOT TARGET fetch_${name})
    add_custom_target(fetch_${name} COMMAND ${cmd} WORKING_DIRECTORY ${config_dir})
  endif()
endfunction()

function(build_package name config_dir)
  ep_build_command(cmd ${name} ${config_dir})

  if(${ARGC} EQUAL 2)
    run_command(
      "${cmd}"
      ${config_dir})
  endif()

  if(NOT TARGET build_${name})
    add_custom_target(build_${name} COMMAND ${cmd} WORKING_DIRECTORY ${config_dir})
  endif()
endfunction()

function(install_package name config_dir)
  ep_install_command(cmd ${name} ${config_dir})

  if(${ARGC} EQUAL 2)
    run_command(
      "${cmd}"
      ${config_dir})
  endif()

  if(NOT TARGET install_${name})
    add_custom_target(install_${name} COMMAND ${cmd} WORKING_DIRECTORY ${config_dir})
  endif()
endfunction()

function(extract_find_package_arguments out rest)
  set(options

    # REQUIRED ignore required.
    EXACT QUIET GLOBAL CONFIG NO_MODULE
    NO_POLICY_SCOPE BYPASS_PROVIDER
    NO_DEFAULT_PATH NO_PACKAGE_ROOT_PATH NO_CMAKE_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_INSTALL_PREFIX
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    CMAKE_FIND_ROOT_PATH_BOTH ONLY_CMAKE_FIND_ROOT_PATH NO_CMAKE_FIND_ROOT_PATH
  )
  DEBUG_MSG("in.extract.input; ${ARGN}")
  set(oneValueArgs VERSION REGISTRY_VIEW)
  set(multiValueArgs COMPONENTS OPTIONAL_COMPONENTS NAMES CONFIGS HINTS PATHS PATH_SUFFIXES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(DEFINED ARG_VERSION)
    set(find_package_args ${ARG_VERSION})
  else()
    set(find_package_args "")
  endif()

  foreach(op ${options})
    if(ARG_${op})
      set(find_package_args ${find_package_args} ${op})
    endif()
  endforeach()

  if(DEFINED ARG_REGISTRY_VIEW)
    set(find_package_args ${find_package_args} REGISTRY_VIEW ${ARG_REGISTRY_VIEW})
  endif()

  foreach(mv ${multiValueArgs})
    if(DEFINED ARG_${mv})
      set(find_package_args ${find_package_args} ${mv} ${ARG_${mv}})
    endif()
  endforeach()

  DEBUG_MSG("in.extract.find.args: ${find_package_args}")
  set(${out} ${find_package_args} PARENT_SCOPE)
  set(${rest} ${ARG_UNPARSED_ARGUMENTS} PARENT_SCOPE)
endfunction()

# TODO.
function(extract_add_subdir_arguments out rest)
  cmake_parse_arguments(SUB "EXCLUDE_FROM_ALL" "" "" ${ARGN})

  if(SUB_EXCLUDE_FROM_ALL)
    set(args ${args} EXCLUDE_FROM_ALL)
  endif()

  set(${out} ${args} PARENT_SCOPE)
  DEBUG_MSG("In extract.sub: ${args}")
  set(${rest} ${SUB_UNPARSED_ARGUMENTS} PARENT_SCOPE)
endfunction()

# FIXME. the same reason with do_find_package.
macro(core_require_package name)
  set(args ${ARGN})
  set(options LOCAL_FIRST_OFF REQUIRED NOT_REQUIRED DEFER
    IMPORT_AS_SUBDIR SUBDIR_ONLY GEN_PKG_TARGETS)
  set(oneValueArgs)
  set(multiValueArgs CMAKE_ARGS)
  cmake_parse_arguments(PKG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${args})

  # check args.
  if(PKG_REQUIRED AND PKG_NOT_REQUIRED)
    ERROR_MSG("[core_require_package]: Cannot specify REQUIRED and NOT_REQUIRED at the same time!")
  endif()

  DEBUG_MSG("PKG_UNPARSED_ARGS: ${PKG_UNPARSED_ARGUMENTS}")
  extract_find_package_arguments(find_package_args rest_args ${PKG_UNPARSED_ARGUMENTS})
  DEBUG_MSG("after.find.rest: ${rest_args}")
  extract_add_subdir_arguments(subdir_args rest_args ${rest_args})
  DEBUG_MSG("after.subdir.rest: ${rest_args}")

  # TODO.
  if(DEFINED PKG_CMAKE_ARGS)
    set(configure_package_args ${rest_args} CMAKE_ARGS ${PKG_CMAKE_ARGS})
  else()
    set(configure_package_args ${rest_args})
  endif()

  DEBUG_MSG("Extract.FindPackage.Args: ${find_package_args}")
  DEBUG_MSG("Extract.SubDir.Args: ${subdir_args}")
  DEBUG_MSG("Extract.ExtProj.Args: ${configure_package_args}")

  cmake_parse_arguments(PKG "DOWNLOAD_ONLY" "" "" ${configure_package_args})
  DEBUG_MSG("DOWNLOAD_ONLY: ${PKG_DOWNLOAD_ONLY}")

  # configure package
  # TODO. Not necessary to configure everytime!
  if (PKG_GEN_PKG_TARGETS)
    ep_configure_package(${name} ${configure_package_args} OUT_CONFIG_DIR OUT_SOURCE_DIR OUT_INSTALL_DIR)
    fetch_package(${name} ${EP_CONFIG_DIR} DEFER)
    install_package(${name} ${EP_CONFIG_DIR} DEFER)
    set(${name}_SOURCE_DIR ${EP_SOURCE_DIR})
    set(${name}_CONFIG_DIR ${EP_CONFIG_DIR})
  endif()

  if((NOT PKG_LOCAL_FIRST_OFF)
      AND (NOT PKG_SUBDIR_ONLY)
    AND EXT_PACKAGE_LOCAL_FIRST
    AND(NOT PKG_DOWNLOAD_ONLY))
    ep_find_package(${name} ${find_package_args} QUIET)
  else()
    set(PKG_FOUND OFF)
  endif()

  if(NOT(PKG_FOUND OR PKG_NOT_REQUIRED))
    if(NOT PKG_NOT_REQUIRED)
      list(APPEND find_package_args REQUIRED)
    endif()

    # TODO. Not necessary to configure everytime!
    if (NOT PKG_GEN_PKG_TARGETS)
      ep_configure_package(${name} ${configure_package_args} OUT_CONFIG_DIR OUT_SOURCE_DIR OUT_INSTALL_DIR)
      fetch_package(${name} ${EP_CONFIG_DIR} DEFER)
      install_package(${name} ${EP_CONFIG_DIR} DEFER)
      set(${name}_SOURCE_DIR ${EP_SOURCE_DIR})
      set(${name}_CONFIG_DIR ${EP_CONFIG_DIR})
    endif()

    if(NOT PKG_DEFER)
      if(PKG_IMPORT_AS_SUBDIR OR PKG_SUBDIR_ONLY OR EXT_PACKAGE_IMPORT_AS_SUBDIR)
        DEBUG_MSG("import as subdir: ${name}")
        # not fetch everytime.
        if (NOT EXISTS ${EP_SOURCE_DIR}/CMakeLists.txt)
          fetch_package(${name} ${EP_CONFIG_DIR})
        endif()
        ASSERT_DEFINED(EP_SOURCE_DIR)
        ASSERT_PATH_EXISTS(${EP_SOURCE_DIR})
        ep_add_subdirectory(${EP_SOURCE_DIR} ${EXT_PACKAGE_BUILD_BASE_DIR}/${name} ${subdir_args} CMAKE_ARGS ${PKG_CMAKE_ARGS})
      elseif(PKG_DOWNLOAD_ONLY)
        # not fetch everytime.
        file(GLOB __srcs ${EP_SOURCE_DIR}/*)
        list(LENGTH __srcs __num)
        if (__num EQUAL 0)
          fetch_package(${name} ${EP_CONFIG_DIR})
        endif()
        unset(__srcs)
        unset(__num)
      else()
        DEBUG_MSG("build_and_install ${name}")
        install_package(${name} ${EP_CONFIG_DIR})
        ASSERT_DEFINED(EP_INSTALL_DIR)
        ASSERT_PATH_EXISTS(${EP_INSTALL_DIR})
        set(${name}_ROOT ${EP_INSTALL_DIR})
        ep_find_package(${name} ${find_package_args})
      endif()
    endif()
  endif()

  unset(args)
  unset(options)
  unset(oneValueArgs)
  unset(multiValueArgs)
  unset(find_package_args)
  unset(subdir_args)
  unset(configure_package_args)
  unset(EP_SOURCE_DIR)
  unset(EP_BINARY_DIR)
  unset(EP_INSTALL_DIR)
endmacro()

function(is_version out v)
  # major[.minor[.patch[.tweak]]]
  string(REGEX MATCH "^[0-9]+(.[0-9]+)?(.[0-9]+)?(.[0-9]+)?$" _ ${v})

  if(_)
    set(${out} YES PARENT_SCOPE)
  else()
    set(${out} NO PARENT_SCOPE)
  endif()
endfunction()

function(infer_version_from_tag out tag)
  DEBUG_MSG("Test.Case: ${tag}")

  if(${tag} MATCHES "^[^0-9]*([0-9]+[0-9.]*)([^0-9]+.*)*$")
    is_version(_ ${CMAKE_MATCH_1})

    if(_)
      DEBUG_MSG("infer.version: ${CMAKE_MATCH_1}")
      set(${out} ${CMAKE_MATCH_1} PARENT_SCOPE)
    else()
      unset(${out} PARENT_SCOPE)
    endif()
  else()
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

function(infer_args_from_uri out_args uri)
  cmake_parse_arguments("" "NO_VERSION" "" "" ${ARGN})
  DEBUG_MSG("-----Current.uri: ${uri}")

  # split uri to url#tagversion
  if(${uri} MATCHES "^([^# ]+)(#[^# ]*)?$")
    set(url ${CMAKE_MATCH_1})

    if(CMAKE_MATCH_2)
      string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 tagversion)
    endif()
  else()
    ERROR_MSG("Unvalid URI Format(^[^# ]+(#[^# ]*)?$): ${uri}")
  endif()

  # split tagversion: tag@version
  if(tagversion)
    if(tagversion MATCHES "^([^@]*)(@[0-9.]*)?$")
      set(tag ${CMAKE_MATCH_1})

      # infer version.
      if(NOT _NO_VERSION)
        if(CMAKE_MATCH_2)
          string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 version)
        else()
          infer_version_from_tag(version ${tag})
        endif()
      endif()
    else()
      ERROR_MSG("Unvalid TagVersion Format([^@]*@[0-9.]*): ${tagversion}")
    endif()
  endif()

  DEBUG_MSG("tag: ${tag}")
  DEBUG_MSG("version: ${version}")

  # infer scheme from url.
  # scheme:path
  if(${url} MATCHES "^([^: ]+):(.+)$")
    string(TOLOWER ${CMAKE_MATCH_1} scheme)
    set(path ${CMAKE_MATCH_2})
    DEBUG_MSG("Current.Match.Scheme: ${scheme}")
    DEBUG_MSG("Current.Match.Path: ${path}")
  endif()

  # some special schemes
  if(scheme STREQUAL "rom") # ryon.ren:mirrors
    if(${path} MATCHES "([^/]+)$")
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

  if(tag)
    if(${type} STREQUAL git)
      set(out ${out} GIT_TAG ${tag})
    else()
      set(out ${out} URL_HASH ${tag})
    endif()
  endif()

  if(version)
    set(out ${out} VERSION ${version})
  endif()

  DEBUG_MSG("Current.Prepare.args: ${out}")

  set(${out_args} ${out} PARENT_SCOPE)
endfunction()

# FIXME. the same reason with ep_find_package.
macro(require_package name) # [uri]
  set(args ${ARGN})

  # extract uri from args.
  set(uri ${ARGN})
  list(FILTER uri INCLUDE REGEX "^([^#: ]+):([^# ]+)(#[^# ]*)?$")
  list(LENGTH uri NUM_URI)
  ASSERT_LESS_EQUAL(${NUM_URI} 1)
  list(REMOVE_ITEM args ${uri})
  DEBUG_MSG("uri: ${uri}")
  DEBUG_MSG("args: ${args}")

  if(${NUM_URI} EQUAL 1)
    # URI to Args.
    infer_args_from_uri(extra_args "${uri}")
  else()
    set(extra_args "")
  endif()

  DEBUG_MSG("extra_args: ${extra_args}")
  core_require_package(${name} ${extra_args} ${args})

  unset(args)
  unset(uri)
  unset(extra_args)
endmacro()
