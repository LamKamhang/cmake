include_guard()

# if Eigen3::Eigen has been found
if (TARGET Eigen3::Eigen)
  return()
endif()

message(STATUS "[package/Eigen3]: Eigen3::Eigen")

option(eigen_APPLY_CHOLMOD_PATCH "Apply cholmod patch for eigen" ON)

if (NOT DEFINED eigen_VERSION)
  set(eigen_VERSION "3.4.0")
endif()
if (NOT DEFINED eigen_TAG)
  set(eigen_TAG "${eigen_VERSION}")
endif()

set(_args "gl:libeigen/eigen#${eigen_TAG}" NAME Eigen3)
if (eigen_APPLY_CHOLMOD_PATCH)
  list(APPEND _args
    GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/cholmod.patch")
endif()

lam_add_package_maybe_prebuild(
  ${_args}
  CMAKE_ARGS
  "-DEIGEN_BUILD_DOC=OFF"
  "-DBUILD_TESTING=OFF"
  # for user customize.
  ${eigen_USER_CUSTOMIZE_ARGS}
)
