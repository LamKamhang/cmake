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

require_package(autodiff "gh:autodiff/autodiff#${autodiff_TAG}"
  GIT_PATCH "${CMAKE_CURRENT_LIST_DIR}/num_traits.patch"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF")
