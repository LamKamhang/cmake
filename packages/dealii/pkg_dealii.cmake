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

lam_check_prefer_prebuilt(out dealii)
# dealII only support prebuilt mode.
lam_assert_truthy(out)
lam_add_prebuilt_package(
  "gh:dealii/dealii#${dealii_TAG}"
  NAME deal.II
  GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/dealii_setup_target.patch"
  CMAKE_ARGS
  "-DBUILD_SHARED_LIBS=ON"
  "-DDEAL_II_COMPONENT_EXAMPLES=OFF"
  "-DDEAL_II_COMPONENT_DOCUMENTATION=OFF"
  "-DDEAL_II_COMPONENT_PYTHON_BINDINGS=OFF"
  # for user customize.
  ${dealii_USER_CMAKE_ARGS}
)
if (NOT TARGET dealii::dealii)
  add_library(dealii::dealii ALIAS ${DEAL_II_TARGET})
endif()

deal_ii_initialize_cached_variables()
