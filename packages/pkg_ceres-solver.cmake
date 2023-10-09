include_guard()

# if Ceres::ceres has been found
if (TARGET Ceres::ceres)
  return()
endif()

message(STATUS "[package/ceres-solver]: Ceres::ceres")

if (NOT DEFINED ceres-solver_VERSION)
  set(ceres-solver_VERSION "2.1.0")
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
  # for user customize.
  ${ceres-solver_USER_CUSTOM_ARGS}
)
