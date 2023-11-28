include_guard()

# if ifopt::ifopt_ipopt has been found
if (TARGET ifopt::ifopt_ipopt)
  return()
endif()
if (TARGET ifopt_ipopt)
  add_library(ifopt::ifopt_ipopt ALIAS ifopt_ipopt)
  return()
endif()

message(STATUS "[package/ifopt]: ifopt::ifopt_ipopt")


if (NOT DEFINED ifopt_VERSION)
  set(ifopt_VERSION "2.1.3")
endif()
if (NOT DEFINED ifopt_TAG)
  set(ifopt_TAG "${ifopt_VERSION}")
endif()

lam_check_prefer_prebuilt(out ifopt)
lam_add_package_maybe_prebuilt(ifopt
  "gh:ethz-adrl/ifopt#${ifopt_TAG}"
  NAME ifopt
  GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/notest_fixeigen.patch"
  CMAKE_ARGS
  "-DCMAKE_PREFIX_PATH=${LAM_PACKAGE_INSTALL_PREFIX}"
  # for user customize.
  ${ifopt_USER_CUSTOM_ARGS}
)
