set(_CORE_PACKAGE_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(EXTERNAL_PROJECT_BASE_DIR ${CMAKE_SOURCE_DIR}/3rd)

function(get_default_ep_source_dir outdir name) # [prefix]
  if (NOT (ARGC EQUAL 2 OR ARGC EQUAL 3))
    ERROR_MSG("get_default_ep_source_dir <outdir> <name> [prefix]")
  endif()

  if (ARGC EQUAL 2)
    set(base_dir ${EXTERNAL_PROJECT_BASE_DIR})
  else()
    set(base_dir ${ARGV2})
  endif()
  set(${outdir} ${base_dir}/${name} PARENT_SCOPE)
endfunction()

function(get_default_ep_config_dir outdir name) # [prefix]
  if (NOT (ARGC EQUAL 2 OR ARGC EQUAL 3))
    ERROR_MSG("get_default_ep_config_dir <outdir> <name> [prefix]")
  endif()

  if (ARGC EQUAL 2)
    set(base_dir ${EXTERNAL_PROJECT_BASE_DIR})
  else()
    set(base_dir ${ARGV2})
  endif()
  set(${outdir} ${base_dir}/.cache/.ep_config/${name} PARENT_SCOPE)
endfunction()

function(get_default_ep_install_dir outdir name) # [build-type [prefix]]
  if (NOT (ARGC EQUAL 2 OR ARGC EQUAL 3 OR ARGC EQUAL 4))
    ERROR_MSG("get_default_ep_install_dir <outdir> <name> [build-type [prefix]]!")
  endif()
  set(base_dir ${EXTERNAL_PROJECT_BASE_DIR})
  if (ARGC EQUAL 2)
    set(build_type release)
  else()
    string(TOLOWER ${ARGV2} build_type)
  endif()
  if (ARGC EQUAL 4)
    set(base_dir ${ARGV3})
  endif()
  set(${outdir} ${base_dir}/install/${build_type}/${name} PARENT_SCOPE)
endfunction()

# https://cmake.org/cmake/help/latest/module/ExternalProject.html
function(configure_extproj name)
  DEBUG_MSG("configure-extproj: ARGV: ${ARGV}")
  DEBUG_MSG("configure-extproj: ARGC: ${ARGC}")
  DEBUG_MSG("configure-extproj: ARGN: ${ARGN}")

  # provide some preset.
  set(options DOWNLOAD_ONLY BUILD_STATIC
    OUT_SOURCE_DIR OUT_INSTALL_DIR OUT_CONFIG_DIR
    )
  set(oneValueArgs
    BUILD_TYPE
    PREFIX TMP_DIR STAMP_DIR LOG_DIR
    DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR
    )
  set(multiValueArgs STEP_TARGETS)
  cmake_parse_arguments(EP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # configure some arguments.
  if (NOT DEFINED EP_BUILD_TYPE)
    set(EP_BUILD_TYPE release)
  else()
    # NOTE: string(TOLOWER <string> <output_variable>)
    string(TOLOWER ${EP_BUILD_TYPE} EP_BUILD_TYPE)
  endif()
  set(EP_NAME ${name})

  # NOTE: DO NOT ALLOW TO ReDefine these DIRS:
  ASSERT_NOT_DEFINED(
    EP_TMP_DIR EP_STAMP_DIR EP_LOG_DIR EP_BINARY_DIR
    EP_STEP_TARGETS
    )
  if (NOT DEFINED EP_PREFIX)
    set(EP_PREFIX ${EXTERNAL_PROJECT_BASE_DIR})
  endif()
  get_filename_component(EP_PREFIX ${EP_PREFIX} ABSOLUTE
    BASE_DIR ${CMAKE_CURRENT_BINARY_DIR})
  get_default_ep_config_dir(EP_CONFIG_DIR ${EP_NAME} ${EP_PREFIX})
  set(EP_TMP_DIR ${EP_CONFIG_DIR}/tmp)
  set(EP_STAMP_DIR ${EP_CONFIG_DIR}/stamp)
  set(EP_LOG_DIR ${EP_CONFIG_DIR}/log)
  if ((NOT DEFINED EP_DOWNLOAD_DIR) AND (NOT DEFINED EP_SOURCE_DIR))
    get_default_ep_source_dir(EP_SOURCE_DIR ${EP_NAME} ${EP_PREFIX})
  elseif(NOT DEFINED EP_SOURCE_DIR)
    set(EP_SOURCE_DIR ${EP_DOWNLOAD_DIR})
  endif()
  set(EP_BINARY_DIR ${EP_CONFIG_DIR}/build-${EP_BUILD_TYPE})
  if (NOT DEFINED EP_INSTALL_DIR)
    get_default_ep_install_dir(EP_INSTALL_DIR
      ${EP_NAME} ${EP_BUILD_TYPE} ${EP_PREFIX})
  endif()
  set(EP_STEP_TARGETS update patch build install)

  # TODO. refine arguments.
  set(EP_ARGS ${EP_UNPARSED_ARGUMENTS})
  # prepare preset.
  if (EP_DOWNLOAD_ONLY)
    set(EchoCMD "${CMAKE_COMMAND} -E echo do nothing.")
    set(EP_ARGS
      CONFIGURE_COMMAND ${EchoCMD}
      BUILD_COMMAND     ${EchoCMD}
      TEST_COMMAND      ${EchoCMD}
      INSTALL_COMMAND   ${EchoCMD}
      ${EP_ARGS})
  endif()

  if (NOT EP_BUILD_STATIC)
    set(EP_ARGS ${EP_ARGS}
      CMAKE_ARGS "-DBUILD_SHARED_LIBS=ON"
      # https://cmake.org/cmake/help/latest/prop_tgt/POSITION_INDEPENDENT_CODE.html
      # flags **-fPIC** will be automatically set.
      )
  endif()

  # configure the exrproj
  configure_file(${_CORE_PACKAGE_BASE_DIR}/extproj.cmake.in
    ${EP_CONFIG_DIR}/CMakeLists.txt @ONLY)
  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -G ${CMAKE_GENERATOR}
    -S ${EP_CONFIG_DIR}
    -B ${EP_TMP_DIR}/build
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${EP_CONFIG_DIR}
    )
  if (result)
    ERROR_MSG("Configure ExternalProject(${EP_NAME}) Failed: ${result}")
  endif()
  # TODO. maybe register these in some file is better.
  if (EP_OUT_SOURCE_DIR)
    set(EP_SOURCE_DIR ${EP_SOURCE_DIR} PARENT_SCOPE)
  endif()
  if (EP_OUT_INSTALL_DIR)
    set(EP_INSTALL_DIR ${EP_INSTALL_DIR} PARENT_SCOPE)
  endif()
  if (EP_OUT_CONFIG_DIR)
    set(EP_CONFIG_DIR ${EP_CONFIG_DIR} PARENT_SCOPE)
  endif()
endfunction()

function(prepare_extproj_cmd out_cmd config_dir)
  DEBUG_MSG("prepare_cmd.config_dir: ${config_dir}")
  DEBUG_MSG("prepare_cmd.argn: ${ARGN}")
  ASSERT_EXISTS(${config_dir})
  set(${out_cmd}
    ${CMAKE_COMMAND}
    --build ${config_dir}/tmp/build
    --target ${ARGN}
    PARENT_SCOPE)
endfunction()

function(run_extproj_cmd cmd config_dir)
  DEBUG_MSG("RUN.EXTPROJ.CMD: ${cmd}")
  DEBUG_MSG("RUN.EXTPROJ.ConfigDir: ${config_dir}")
  ASSERT_EQUAL(${ARGC} 2)
  ASSERT_EXISTS(${config_dir})
  execute_process(
    COMMAND ${cmd}
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${config_dir}
    )
  if (result)
    ERROR_MSG("RUN.EXTPROJ.CMD failed: ${cmd}")
  endif()
endfunction()

function(generate_extproj_targets name config_dir)
  update_extproj_cmd(cmd ${name} ${config_dir})
  add_custom_target(update_${name}
    COMMAND ${cmd}
    WORKING_DIRECTORY ${config_dir})
  if (TARGET update_all3rd)
    add_dependencies(update_all3rd update_${name})
  endif()
  build_extproj_cmd(cmd ${name} ${config_dir})
  add_custom_target(build_${name}
    COMMAND ${cmd}
    WORKING_DIRECTORY ${config_dir})
  if (TARGET build_all3rd)
    add_dependencies(build_all3rd build_${name})
  endif()
  install_extproj_cmd(cmd ${name} ${config_dir})
  add_custom_target(install_${name}
    COMMAND ${cmd}
    WORKING_DIRECTORY ${config_dir})
  if (TARGET install_all3rd)
    add_dependencies(install_all3rd install_${name})
  endif()
endfunction()

function(update_extproj_cmd cmd name config_dir)
  ASSERT_EXISTS(${config_dir})
  prepare_extproj_cmd(_ ${config_dir} ${name}-update ${name}-patch)
  DEBUG_MSG("update.cmd: ${_}")
  set(${cmd} ${_} PARENT_SCOPE)
endfunction()

function(update_extproj name) # [config_dir]
  if (NOT (ARGC EQUAL 1 OR ARGC EQUAL 2))
    ERROR_MSG("update_extproj <name> [config_dir]")
  endif()
  if (ARGC EQUAL 1)
    get_default_ep_config_dir(config_dir ${name})
  else()
    set(config_dir ${ARGV1})
  endif()
  ASSERT_EXISTS(${config_dir})
  update_extproj_cmd(cmd ${name} ${config_dir})
  DEBUG_MSG("Current.cmd: ${cmd}")
  run_extproj_cmd("${cmd}" "${config_dir}")
endfunction()

function(build_extproj_cmd cmd name config_dir)
  ASSERT_EXISTS(${config_dir})
  prepare_extproj_cmd(_ ${config_dir} ${name}-build)
  DEBUG_MSG("build.cmd: ${_}")
  set(${cmd} ${_} PARENT_SCOPE)
endfunction()

function(build_extproj name) # [config_dir]
  if (NOT (ARGC EQUAL 1 OR ARGC EQUAL 2))
    ERROR_MSG("build_extproj <name> [config_dir]")
  endif()
  if (ARGC EQUAL 1)
    get_default_ep_config_dir(config_dir ${name})
  else()
    set(config_dir ${ARGV1})
  endif()
  ASSERT_EXISTS(${config_dir})
  build_extproj_cmd(cmd ${name} ${config_dir})
  DEBUG_MSG("Current.cmd: ${cmd}")
  run_extproj_cmd("${cmd}" "${config_dir}")
endfunction()

function(install_extproj_cmd cmd name config_dir)
  ASSERT_EXISTS(${config_dir})
  prepare_extproj_cmd(_ ${config_dir} ${name}-install)
  DEBUG_MSG("install.cmd: ${_}")
  set(${cmd} ${_} PARENT_SCOPE)
endfunction()

function(install_extproj name) # [config_dir]
  if (NOT (ARGC EQUAL 1 OR ARGC EQUAL 2))
    ERROR_MSG("install_extproj <name> [config_dir]")
  endif()
  if (ARGC EQUAL 1)
    get_default_ep_config_dir(config_dir ${name})
  else()
    set(config_dir ${ARGV1})
  endif()

  ASSERT_EXISTS(${config_dir})
  install_extproj_cmd(cmd ${name} ${config_dir})
  DEBUG_MSG("Current.cmd: ${cmd}")
  run_extproj_cmd("${cmd}" "${config_dir}")
endfunction()

# find_package(<PackageName> [version] [EXACT] [QUIET]
#              [REQUIRED] [[COMPONENTS] [components...]]
#              [OPTIONAL_COMPONENTS components...]
#              [CONFIG|NO_MODULE]
#              [GLOBAL]
#              [NO_POLICY_SCOPE]
#              [BYPASS_PROVIDER]
#              [NAMES name1 [name2 ...]]
#              [CONFIGS config1 [config2 ...]]
#              [HINTS path1 [path2 ... ]]
#              [PATHS path1 [path2 ... ]]
#              [REGISTRY_VIEW  (64|32|64_32|32_64|HOST|TARGET|BOTH)]
#              [PATH_SUFFIXES suffix1 [suffix2 ...]]
#              [NO_DEFAULT_PATH]
#              [NO_PACKAGE_ROOT_PATH]
#              [NO_CMAKE_PATH]
#              [NO_CMAKE_ENVIRONMENT_PATH]
#              [NO_SYSTEM_ENVIRONMENT_PATH]
#              [NO_CMAKE_PACKAGE_REGISTRY]
#              [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
#              [NO_CMAKE_SYSTEM_PATH]
#              [NO_CMAKE_INSTALL_PREFIX]
#              [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
#              [CMAKE_FIND_ROOT_PATH_BOTH |
#               ONLY_CMAKE_FIND_ROOT_PATH |
#               NO_CMAKE_FIND_ROOT_PATH])
#
# default, require_package is set to REQUIRED.

function(do_find_package PKG)
  find_package(${PKG} ${ARGN})
  if (${PKG}_FOUND)
    message("Find ${PKG} with version: ${${PKG}_VERSION}")
    # RegisterPackage or NOT?
    set(PKG_FOUND TRUE PARENT_SCOPE)
    set(PKG_VERSION ${${PKG}_VERSION} PARENT_SCOPE)
  else()
   set(PKG_FOUND FALSE PARENT_SCOPE)
  endif()
endfunction()

function(is_version out v)
  # major[.minor[.patch[.tweak]]]
  string(REGEX MATCH "^[0-9]+(.[0-9]+)?(.[0-9]+)?(.[0-9]+)?$" _ ${v})
  set(${out} ${_} PARENT_SCOPE)
endfunction()

function(prepare_arguments out_find_package_args out_extproj_args name)
  set(options EXACT QUIET REQUIRED GLOBAL CONFIG NO_MODULE
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
  set(oneValueArgs VERSION REGISTRY_VIEW)
  set(multiValueArgs COMPONENTS OPTIONAL_COMPONENTS NAMES CONFIGS HINTS PATHS PATH_SUFFIXES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs};EP_ARGS" ${ARGN})

  set(extproj_args ${name} ${ARG_UNPARSED_ARGUMENTS} ${ARG_EP_ARGS})
  if (DEFINED ARG_VERSION)
    set(find_package_args ${name} ${ARG_VERSION})
  else()
    set(find_package_args ${name})
  endif()

  foreach(op ${options})
    if (ARG_${op})
      set(find_package_args ${find_package_args} ${op})
    endif()
  endforeach()
  if (DEFINED ARG_REGISTRY_VIEW)
    set(find_package_args ${find_package_args} REGISTRY_VIEW ${ARG_REGISTRY_VIEW})
  endif()
  foreach(mv ${multiValueArgs})
    if (DEFINED ARG_${mv})
      set(find_package_args ${find_package_args} ${mv} ${ARG_${mv}})
    endif()
  endforeach()

  set(${out_find_package_args} ${find_package_args} PARENT_SCOPE)
  set(${out_extproj_args} ${extproj_args} PARENT_SCOPE)
endfunction()

function(_require_package2 name version)
  require_package(${name} VERSION ${version} ${ARGN})
endfunction()

function(require_package name) # [version]
  if (NOT ARGC EQUAL 1)
    is_version(out ${ARGV1})
    if (out)
      _require_package2(${ARGV})
      return()
    endif()
  endif()

  set(options FIND_FIRST_OFF REQUIRED NOT_REQUIRED
    IMPORT_AS_SUBDIR EXPORT_PM_TARGET EXCLUDE_FROM_ALL
    )
  set(oneValueArgs)
  set(multiValueArgs)
  cmake_parse_arguments(PKG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # prepare FIND_PACKAGE_ARGS.
  if (PKG_REQUIRED AND PKG_NOT_REQUIRED)
    ERROR_MSG("[require_package]: Cannot specify REQUIRED and NOT_REQUIRED at the same time!")
  endif()

  prepare_arguments(find_package_args extproj_args ${name} ${PKG_UNPARSED_ARGUMENTS})

  DEBUG_MSG("require.package.args: ${find_package_args}")
  DEBUG_MSG("require.package.ext.args: ${extproj_args}")

  if (NOT PKG_FIND_FIRST_OFF)
    do_find_package(${find_package_args})
  endif()

  if (PKG_FOUND OR PKG_NOT_REQUIRED)
    return()
  endif()

  if (NOT PKG_NOT_REQUIRED)
    set(find_package_args ${find_package_args} REQUIRED)
  endif()

  configure_extproj(${extproj_args} OUT_CONFIG_DIR OUT_SOURCE_DIR OUT_INSTALL_DIR)
  update_extproj(${name} ${EP_CONFIG_DIR})

  if (PKG_IMPORT_AS_SUBDIR)
    ASSERT_DEFINED(EP_SOURCE_DIR)
    ASSERT_EXISTS(${EP_SOURCE_DIR})
    ASSERT_EXISTS(${EP_SOURCE_DIR}/CMakeLists.txt)
    # TODO. maybe use Options will be better.
    cmake_parse_arguments(ARGS "" "" "CMAKE_ARGS" ${extproj_args})
    foreach(option ${ARGS_CMAKE_ARGS})
      if (${option} MATCHES "^-D([^ ]*)=([^ ]*)$")
        DEBUG_MSG("KEY: ${CMAKE_MATCH_1}, VALUE: ${CMAKE_MATCH_2}")
        set(${CMAKE_MATCH_1} ${CMAKE_MATCH_2})
      else()
        DEBUG_MSG("UNKNOWN CMAKE_ARGS: ${option}")
      endif()
    endforeach()
    if (PKG_EXCLUDE_FROM_ALL)
      add_subdirectory(${EP_SOURCE_DIR} EXCLUDE_FROM_ALL)
    else()
      add_subdirectory(${EP_SOURCE_DIR})
    endif()
  else()
    install_extproj(${name} ${EP_CONFIG_DIR})
    ASSERT_DEFINED(EP_INSTALL_DIR)
    ASSERT_EXISTS(${EP_INSTALL_DIR})
    set(${name}_ROOT ${EP_INSTALL_DIR})
    do_find_package(${find_package_args})
  endif()
endfunction()

function(is_url out url)
  # FIXME. simply check only.
  if (${url} MATCHES "://" OR ${url} MATCHES "@")
    set(${out} True PARENT_SCOPE)
  else()
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

# TODO. not correctly to handle different download method.
function(_add_package name url)
  cmake_parse_arguments(PKG "" "GIT_TAG" "" ${ARGN})
  if (DEFINED PKG_GIT_TAG)
    add_package(${name} GIT_REPOSITORY ${url} ${ARGN})
  else()
    add_package(${name} URL ${url} ${ARGN})
  endif()
endfunction()

function(add_package name)
  if (NOT ARGC EQUAL 1)
    is_url(out ${ARGV1})
    if (out)
      _add_package(${ARGV})
      return()
    endif()
  endif()

  set(options
    UPDATE_NOW BUILD_NOW INSTALL_NOW
    )
  cmake_parse_arguments(PKG "${options}" "" "" ${ARGN})
  configure_extproj(${ARGV} OUT_CONFIG_DIR)
  generate_extproj_targets(${name} ${EP_CONFIG_DIR})
  if (PKG_UPDATE_NOW)
    update_extproj(${name} ${EP_CONFIG_DIR})
  endif()
  if (PKG_BUILD_NOW)
    build_extproj(${name} ${EP_CONFIG_DIR})
  endif()
  if (PKG_INSTALL_NOW)
    install_extproj(${name} ${EP_CONFIG_DIR})
  endif()
endfunction()
