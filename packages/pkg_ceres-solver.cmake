include_guard()

# if Ceres::ceres has been found
if (TARGET Ceres::ceres)
  return()
endif()

message(STATUS "[package/ceres-solver]: Ceres::ceres")

if (NOT DEFINED ceres-solver_VERSION)
  set(ceres-solver_VERSION "2.2.0")
endif()
if (NOT DEFINED ceres-solver_TAG)
  set(ceres-solver_TAG "${ceres-solver_VERSION}")
endif()

lam_check_prefer_prebuilt(out ceres-solver)
lam_add_package_maybe_prebuilt(ceres-solver
  "gh:ceres-solver/ceres-solver#${ceres-solver_TAG}"
  NAME Ceres
  OPTIONS
  "USE_CUDA OFF"
  "GFLAGS OFF"
  "BUILD_TESTING OFF"
  "BUILD_EXAMPLES OFF"
  "BUILD_BENCHMARKS OFF"
  "PROVIDE_UNINSTALL_TARGET OFF"
  "MINIGLOG ON"
  CMAKE_ARGS
  "-DCMAKE_MODULE_PATH=${LAM_CMAKE_UTILITY_BASE_DIR}/find_modules"
  "-DCMAKE_PREFIX_PATH=${LAM_PACKAGE_INSTALL_PREFIX}"
  # for user customize.
  ${ceres-solver_USER_CUSTOM_ARGS}
)

if (NOT TARGET ceres)
  message(FATAL_ERROR "failed to find target ceres")
endif()

if (NOT TARGET Ceres::ceres)
  add_library(Ceres::ceres ALIAS ceres)
endif()
