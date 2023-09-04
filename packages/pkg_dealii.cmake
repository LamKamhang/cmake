include_guard()

# if target_name has been found
if (COMMAND deal_ii_setup_target)
  return()
endif()

message(STATUS "[package/deal.II]: target_name")

if (NOT DEFINED dealii_VERSION)
  set(dealii_VERSION "9.5.0")
endif()
if (NOT DEFINED dealii_TAG)
  set(dealii_TAG "v${dealii_VERSION}")
endif()

lam_check_prefer_prebuild(out dealii)
# dealII only support prebuild mode.
lam_assert_truthy(out)
lam_add_prebuild_package(
  "gh:dealii/dealii#${dealii_TAG}"
  NAME deal.II
  # for user customize.
  ${dealii_USER_CMAKE_ARGS}
)
