include_guard()

use_cmake_core_module(lam_assert)
use_cmake_core_module(lam_utils)
# Use to rename the export target.
# For example:
#   in the build-time, the target maybe name as chaos_common
#   and when installing it with a specific namespace chaos::
#   the imported target will be named as: chaos::chaos_common.
#   We do not want such prefix *chaos_*, so we should call this
#   `lam_rename_export_name` function to rename the export-name via:
#   lam_rename_export_name(chaos_common common).
#   Actually, it call the set_target_properties function to complete the rename.
# NOTE: the target name should not be an alias target.
#       the export_name should be unique.
function(lam_rename_export_name target export_name)
  lam_verbose_func()
  lam_assert_num_equal(${ARGC} 2)
  set_target_properties(${target} PROPERTIES EXPORT_NAME ${export_name})
endfunction()

# lam_try_get_package_version is to try its best to infer the version.
function(lam_try_get_package_version out Package)
  string(TOUPPER ${Package} PACKAGE) # upper case
  string(TOLOWER ${Package} package) # lower case
  if (DEFINED ${PACKAGE}_VERSION) # upper case
    set(${out} ${PACKAGE}_VERSION PARENT_SCOPE)
  elseif(DEFINED ${package}_VERSION) # lower case
    set(${out} ${package}_VERSION PARENT_SCOPE)
  elseif(DEFINED ${Package}_VERSION) # normal
    set(${out} ${Package}_VERSION PARENT_SCOPE)
  elseif(DEFINED PROJECT_VERSION)
    set(${out} ${PROJECT_VERSION} PARENT_SCOPE)
  else()
    message(WARNING "cannot determine the version of ${Package}.")
    set(${out} "" PARENT_SCOPE)
  endif()
endfunction()

# this macro is to define some lam's flavor install directorure structure.
macro(lam_define_package_install_dir PackageName DirSuffix VarPrefix)
  include(GNUInstallDirs)
  set(${VarPrefix}_INSTALL_PREFIX ${PackageName}${DirSuffix})
  set(${VarPrefix}_INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR}/${${VarPrefix}_INSTALL_PREFIX})
  set(${VarPrefix}_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${${VarPrefix}_INSTALL_PREFIX})
  set(${VarPrefix}_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${${VarPrefix}_INSTALL_PREFIX})
  set(${VarPrefix}_INSTALL_DATAROOTDIR ${CMAKE_INSTALL_DATAROOTDIR}/${${VarPrefix}_INSTALL_PREFIX})
endmacro()

function(lam_install)
  lam_verbose_func()
  set(options "EXCLUDE_FROM_ALL")
  set(oneValueArgs "PACKAGE;EXPORT_NAME;SUFFIX")
  set(multiValueArgs "TARGETS;DIRECTORY;FILES")
  cmake_parse_arguments(PKG "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")

  if (NOT DEFINED PKG_TARGETS AND NOT DEFINED PKG_DIRECTORY AND NOT DEFINED PKG_FILES)
    message(WARNING "Nothing to be installed.")
    return()
  endif()

  list(LENGTH PKG_TARGETS N_TARGETS)
  # set package_name.
  if (NOT DEFINED PKG_PACKAGE)
    if (NOT ${N_TARGETS} EQUAL 1)
      message(FATAL_ERROR "Cannot determine the package name.")
    else()
      set(PKG_PACKAGE ${PKG_TARGETS})
    endif()
  endif()
  set(PACKAGE_NAME ${PKG_PACKAGE})

 # check export_rename.
  if (DEFINED PKG_EXPORT_NAME)
    if (NOT ${N_TARGETS} EQUAL 1)
      message(FATAL_ERROR "Cannot determine which target(${PKG_TARGETS}) needs to rename as (${PKG_EXPORT_NAME}).")
    else()
      lam_rename_export_name(${PKG_TARGETS} ${PKG_EXPORT_NAME})
    endif()
  endif()

  # check package suffix
  if (NOT DEFINED PKG_SUFFIX)
    lam_try_get_package_version(PKG_SUFFIX ${PACKAGE_NAME})
  endif()

  # use lam's flavor to install the target.
  # add name#suffix to avoid conflicts.
  lam_define_package_install_dir("${PACKAGE_NAME}" "${PKG_SUFFIX}" PACKAGE)

  # prepare extra_args.
  if (PKG_EXCLUDE_FROM_ALL)
    set(PKG_EXCLUDE_FROM_ALL EXCLUDE_FROM_ALL)
  else()
    set(PKG_EXCLUDE_FROM_ALL)
  endif()

  if (DEFINED PKG_TARGETS)
    install(TARGETS ${PKG_TARGETS}
      ${PKG_EXCLUDE_FROM_ALL}
      EXPORT ${PACKAGE_NAME}_Targets
      RUNTIME DESTINATION ${PACKAGE_INSTALL_BINDIR}
      COMPONENT ${PACKAGE_NAME}_Runtime
      LIBRARY DESTINATION ${PACKAGE_INSTALL_LIBDIR}
      COMPONENT ${PACKAGE_NAME}_Runtime
      NAMELINK_COMPONENT ${PACKAGE_NAME}_Development # Requires Cmake 3.12
      ARCHIVE DESTINATION ${PACKAGE_INSTALL_LIBDIR}/static
      COMPONENT ${PACKAGE_ANME}_Runtime
      # This option specifies a list of directories which will be added to
      # the INTERFACE_INCLUDE_DIRECTORIES target property of the <targets>
      # when exported by the install(EXPORT) command.
      # If a relative path is specified, it is treated as relative to the $<INSTALL_PREFIX>.
      INCLUDES DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
    )
  endif()

  if (DEFINED PKG_DIRECTORY)
    cmake_parse_arguments(""
      ""
      ""
      "EXTRAS_ARGS"
      "${PKG_DIRECTORY}"
    )
    install(DIRECTORY ${_UNPARSED_ARGUMENTS}
      DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
      COMPONENT ${PACKAGE_NAME}_Development
      ${_EXTRAS_ARGS}
    )
  endif()

  if (DEFINED PKG_FILES)
    cmake_parse_arguments(""
      ""
      ""
      "EXTRAS_ARGS"
      "${PKG_FILES}"
    )
    install(FILES ${_UNPARSED_ARGUMENTS}
      DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
      COMPONENT ${PACKAGE_NAME}_Development
      ${_EXTRAS_ARGS}
    )
  endif()

endfunction()

function(lam_install_package_config package_name)
  lam_verbose_func()

  cmake_parse_arguments(PKG
    ""
    "CONFIG_IN;VERSION;SUFFIX"
    "DEPS"
    "${ARGN}"
  )

  # Get Version.
  if (NOT DEFINED PKG_VERSION)
    lam_try_get_package_version(PKG_VERSION ${package_name})
  endif()

  lam_is_version(IS_VERSION "${PKG_VERSION}")

  if (NOT DEFINED PKG_SUFFIX)
    set(PKG_SUFFIX "${PKG_VERSION}")
  endif()

  lam_define_package_install_dir("${package_name}" "${PKG_SUFFIX}" PACKAGE)

  if (DEFINED PKG_CONFIG_IN)
    if (NOT EXISTS ${PKG_CONFIG_IN})
      message(WARNING "PackageConfig.cmake.in(${PKG_CONFIG_IN}) does not exists.")
      set(PKG_CONFIG_IN "${LAM_CMAKE_UTILITY_CORE_DIR}/lamConfig.cmake.in")
    endif()
  else()
    set(PKG_CONFIG_IN "${LAM_CMAKE_UTILITY_CORE_DIR}/lamConfig.cmake.in")
  endif()

  if (DEFINED PKG_DEPS)
    set(package_deps ${PKG_DEPS})
  endif()

  set(package_config_in "${PKG_CONFIG_IN}")
  set(package_config_out "${CMAKE_CURRENT_BINARY_DIR}/${package_name}Config.cmake")
  set(config_targets_file "${package_name}ConfigTargets.cmake")
  set(version_config_file "${CMAKE_CURRENT_BINARY_DIR}/${package_name}ConfigVersion.cmake")
  set(export_dest_dir "${PACKAGE_INSTALL_DATAROOTDIR}/cmake")

  install(EXPORT ${package_name}_Targets
    DESTINATION ${export_dest_dir}
    NAMESPACE ${package_name}::
    FILE ${config_targets_file}
    COMPONENT ${package_name}_Development
  )

  include(CMakePackageConfigHelpers)
  configure_package_config_file("${package_config_in}" "${package_config_out}"
    INSTALL_DESTINATION "${export_dest_dir}"
  )

  if (IS_VERSION)
    list(APPEND extra_args VERSION ${PKG_VERSION})
  endif()
  write_basic_package_version_file("${version_config_file}"
    ${extra_args}
    COMPATIBILITY SameMinorVersion
    ARCH_INDEPENDENT
  )

  install(FILES "${package_config_out}" "${version_config_file}"
    DESTINATION "${export_dest_dir}"
  )
endfunction()
