include_guard()

# if Eigen3::Eigen has been found
if (TARGET Eigen3::Eigen)
  return()
endif()

message(STATUS "[package/Eigen3]: Eigen3::Eigen")

option(eigen3_APPLY_CHOLMOD_PATCH "Apply cholmod patch for eigen" ON)

if (NOT DEFINED eigen3_VERSION)
  set(eigen3_VERSION "3.4.0")
endif()
if (NOT DEFINED eigen3_TAG)
  set(eigen3_TAG "${eigen3_VERSION}")
endif()

set(_args "gl:libeigen/eigen#${eigen3_TAG}" NAME Eigen3)
if (eigen3_APPLY_CHOLMOD_PATCH)
  list(APPEND _args
    GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/cholmod.patch")
endif()

lam_add_package_maybe_prebuild(
  ${_args}
  CMAKE_ARGS
  "-DEIGEN_BUILD_DOC=OFF"
  "-DBUILD_TESTING=OFF"
  # for user customize.
  ${eigen3_USER_CUSTOMIZE_ARGS}
)
