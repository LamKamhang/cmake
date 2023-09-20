include_guard()

use_cmake_core_module(assert)

function(lam_install_package)
  lam_verbose_func()
  include(GNUInstallDirs)

  set(options)
  set(oneValueArgs "NAME;EXPORT_NAME;VERSION;INCLUDE_DIR;INCLUDE_DESTINATION")
  set(multiValueArgs)
  cmake_parse_arguments(LAM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(PACKAGE_INSTALL_BINDIR)
  set(PACKAGE_INSTALL_LIBDIR)
  set(PACKAGE_INSTALL_INCLUDEDIR)

  install(TARGETS ${LAM_NAME}
    EXPORT ${LAM_EXPORT_NAME}
    RUNTIME DESTINATION ${PACKAGE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${PACKAGE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${PACKAGE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
    INCLUDES DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
  )

  install(DIRECTORY ${LAM_INCLUDE_DIR}
    DESTINATION ${PACKAGE_INSTALL_INCLUDEDIR}
  )
endfunction()
