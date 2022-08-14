set(_CORE_PACKAGE_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(EXTERNAL_PROJECT_BASE_DIR ${CMAKE_SOURCE_DIR}/3rd)
# Top level:
# Enhanced version of find_package with externalproject_add.
#
# Why not use fetchcontent but wrap it with externalproject_add?
# Because I don't want to import all the targets of external libraries
# through add_submodule, environment isolation is required.
#
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

# https://cmake.org/cmake/help/latest/module/ExternalProject.html
function(add_external_project PKG)
  DEBUG_MSG("AddExternalProject.Argv: ${ARGV}")
  DEBUG_MSG("AddExternalProject.Argc: ${ARGC}")
  DEBUG_MSG("AddExternalProject.Argn: ${ARGN}")

  set(options DOWNLOAD_ONLY BUILD_STATIC GENERATE_TARGET
    GENERATE_TARGET_ONLY)
  set(oneValueArgs
    BUILD_TYPE
    PREFIX TMP_DIR STAMP_DIR LOG_DIR
    DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs "")
  cmake_parse_arguments(EP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # use release as the default build-type.
  if (NOT DEFINED EP_BUILD_TYPE)
    set(EP_BUILD_TYPE release)
  else()
    string(TOLOWER ${EP_BUILD_TYPE} EP_BUILD_TYPE)
  endif()
  if (EP_GENERATE_TARGET_ONLY)
    set(EP_GENERATE_TARGET True)
  endif()
  # TODO. add version/tag/hash to impl version isolation
  set(EP_NAME ${PKG})

  # define default dirs.
  if (NOT DEFINED EP_PREFIX)
    set(EP_PREFIX ${EXTERNAL_PROJECT_BASE_DIR})
  endif()
  get_filename_component(EP_PREFIX ${EP_PREFIX} ABSOLUTE
    BASE_DIR ${CMAKE_CURRENT_BINARY_DIR})
  if (NOT DEFINED EP_TMP_DIR)
    set(EP_TMP_DIR ${EP_PREFIX}/.cache/.ep_config/${EP_NAME})
  endif()
  if (NOT DEFINED EP_STAMP_DIR)
    set(EP_STAMP_DIR ${EP_TMP_DIR}/stamp)
  endif()
  if (NOT DEFINED EP_LOG_DIR)
    set(EP_LOG_DIR ${EP_TMP_DIR}/log)
  endif()
  # NOTE: USE SOURCE_DIR as the path if both DOWNLOAD_DIR and SOURCE_DIR are specified.
  if ((NOT DEFINED EP_DOWNLOAD_DIR) AND (NOT DEFINED EP_SOURCE_DIR))
    set(EP_SOURCE_DIR ${EP_PREFIX}/${EP_NAME})
  elseif(NOT DEFINED EP_SOURCE_DIR)
    set(EP_SOURCE_DIR ${EP_DOWNLOAD_DIR})
  endif()

  if (NOT DEFINED EP_BINARY_DIR)
    set(EP_BINARY_DIR ${EP_TMP_DIR}/build-${EP_BUILD_TYPE})
  endif()
  if (NOT DEFINED EP_INSTALL_DIR)
    set(EP_INSTALL_DIR ${EP_PREFIX}/install/${EP_BUILD_TYPE}/${EP_NAME})
  endif()

  # TODO. CHECK UNPARSED_ARGUMENTS.
  set(EP_ARGS ${EP_UNPARSED_ARGUMENTS})
  if (EP_DOWNLOAD_ONLY)
    set(EP_ARGS
      CONFIGURE_COMMAND "${CMAKE_COMMAND} -E echo do nothing in configure step"
      BUILD_COMMAND     "${CMAKE_COMMAND} -E echo do nothing in build step"
      TEST_COMMAND      "${CMAKE_COMMAND} -E echo do nothing in test step"
      INSTALL_COMMAND   "${CMAKE_COMMAND} -E echo do nothing in install step"
      ${EP_ARGS})
  endif()
  if (NOT EP_BUILD_STATIC)
    set(EP_ARGS ${EP_ARGS}
      CMAKE_ARGS "-DCMAKE_SHARED_LIBS=ON"
      # https://cmake.org/cmake/help/latest/prop_tgt/POSITION_INDEPENDENT_CODE.html
      # flags **-fPIC** will be automatically set.
      )
  endif()

  configure_file(${_CORE_PACKAGE_BASE_DIR}/extproj.cmake.in
    ${EP_TMP_DIR}/CMakeLists.txt @ONLY)
  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -G ${CMAKE_GENERATOR}
    -S ${EP_TMP_DIR}
    -B ${EP_TMP_DIR}/build-config
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${EP_TMP_DIR}
    )
  if (result)
    ERROR_MSG("Cmake Config step for ${EP_NAME} Failed: ${result}")
  endif()
  # TODO. how to configure jobs?
  set(EXEC
    COMMAND ${CMAKE_COMMAND} --build ${EP_TMP_DIR}/build-config -j12)

  if (NOT EP_GENERATE_TARGET_ONLY)
    execute_process(
      ${EXEC}
      RESULT_VARIABLE result
      WORKING_DIRECTORY ${EP_TMP_DIR}
      )
    if (result)
      ERROR_MSG("Cmake Build step for ${EP_NAME} Failed: ${result}")
    endif()
    # export SOURCE_DIR and INSTALL_DIR to parent_scope.
    set(PKG_SOURCE_DIR ${EP_SOURCE_DIR} PARENT_SCOPE)
    set(PKG_INSTALL_DIR ${EP_INSTALL_DIR} PARENT_SCOPE)
  endif()

  if (EP_GENERATE_TARGET)
    add_custom_target(
      update_${EP_NAME} ${EXEC}
      WORKING_DIRECTORY ${EP_TMP_DIR}
      )
    if (TARGET update_all3rd)
      add_dependencies(update_all3rd update_${EP_NAME})
    endif()
  endif()
endfunction()

function(verify_enhance_arguments)
  # if failed, then message(FATAL_ERROR.)
endfunction()

function(require_package PackageName)
  DEBUG_MSG("PackageName.Argv: ${ARGV}")
  DEBUG_MSG("PackageName.Argc: ${ARGC}")
  DEBUG_MSG("PackageName.Argn: ${ARGN}")

  set(options REQUIRED NOT_REQUIRED
    DISABLE_FIND_PKG_FIRST IMPORT_AS_SUBDIR
    SUBDIR_ONLY # this will trigger DISABLE_FIND_PKG_FIRST and IMPORT_AS_SUBDIR
    )
  set(oneValueArgs "")
  set(multiValueArgs EP_ARGS)
  cmake_parse_arguments(PKG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # prepare FIND_PACKAGE_ARGS.
  if (PKG_REQUIRED AND PKG_NOT_REQUIRED)
    ERROR_MSG("[require_package]: Cannot specify REQUIRED and NOT_REQUIRED at the same time!")
  endif()

  if (DEFINED PKG_EP_ARGS)
    set(HAS_SECOND_STAGE True)
  endif()

  # NOTE: consider any unparsed arguments are the find_package args.
  set(FIND_PACKAGE_ARGS ${PKG_UNPARSED_ARGUMENTS})
  if (NOT (PKG_NOT_REQUIRED OR HAS_SECOND_STAGE)) # append REQUIRED option.
    set(FIND_PACKAGE_ARGS ${FIND_PACKAGE_ARGS} REQUIRED)
  endif()
  DEBUG_MSG("FIND.PKG.ARGS: ${FIND_PACKAGE_ARGS}")

  if (PKG_SUBDIR_ONLY)
    set(PKG_DISABLE_FIND_PKG_FIRST True)
    set(PKG_IMPORT_AS_SUBDIR True)
  endif()

  # NOTE: default behavior is to find package first.
  if (PKG_DOWNLOAD_ONLY OR PKG_IMPORT_AS_SUBDIR)
    set(PKG_DISABLE_FIND_PKG_FIRST True)
  endif()

  if (NOT PKG_DISABLE_FIND_PKG_FIRST)
    do_find_package(${PackageName} ${FIND_PACKAGE_ARGS})
    # If PKG is found or is not required, then return.
    if (PKG_FOUND)
      DEBUG_MSG("${PackageName}@${PKG_VERSION} is found in the first find_package staged!")
    endif()
    if (PKG_FOUND OR PKG_NOT_REQUIRED)
      return()
    endif()
  endif()

  # TODO. prepare EP_ARGS
  if (PKG_IMPORT_AS_SUBDIR)
    set(PKG_EP_ARGS ${PKG_EP_ARGS} DOWNLOAD_ONLY)
  endif()
  verify_enhance_arguments(${PKG_EP_ARGS})

  # fall through to use ExternalProject_Add.
  DEBUG_MSG("add_external_project.args: ${PKG_EP_ARGS}")
  add_external_project(${PackageName} ${PKG_EP_ARGS})

  if (PKG_IMPORT_AS_SUBDIR)
    ASSERT_DEFINED(${EP_SOURCE_DIR})
    ASSERT_EXISTS(${EP_SOURCE_DIR})
    add_subdirectory(${EP_SOURCE_DIR})
  else()
    # TODO. set cmake_module_path/cmake_prefix_path.
    do_find_package(${PackageName} ${FIND_PACKAGE_ARGS} REQUIRED)
  endif()
endfunction()

function(add_package name url)
  cmake_parse_arguments(AP "" "GIT_TAG" "" ${ARGN})
  if (NOT DEFINED AP_GIT_TAG)
    add_external_project(
      ${name} URL ${url} ${AP_UNPARSED_ARGUMENTS}
      )
  else()
    add_external_project(
      ${name}
      GIT_REPOSITORY ${url} ${ARGN}
      )
  endif()
endfunction()
