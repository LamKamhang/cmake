include_guard()

# if autodiff::autodiff has been found
if (TARGET autodiff::autodiff)
  return()
endif()

message(STATUS "[package/autodiff]: autodiff::autodiff")

option(autodiff_APPLY_NUM_TRAITS_PATCH "Apply num_traits patch for autodiff[fix float traits.]" ON)

if (NOT DEFINED autodiff_VERSION)
  set(autodiff_VERSION "1.0.3")
endif()
if (NOT DEFINED autodiff_TAG)
  set(autodiff_TAG "v${autodiff_VERSION}")
endif()

set(__args "gh:autodiff/autodiff#${autodiff_TAG}")
if (autodiff_APPLY_NUM_TRAITS_PATCH)
  list(APPEND __args
    GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/num_traits.patch"
  )
endif()

list(APPEND __args
  CMAKE_ARGS
  "-DAUTODIFF_BUILD_TESTS=OFF"
  "-DAUTODIFF_BUILD_PYTHON=OFF"
  "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  "-DAUTODIFF_BUILD_DOCS=OFF"
  # for user customize.
  ${autodiff_USER_CMAKE_ARGS}
)

lam_add_package_maybe_prebuild(autodiff ${__args})
