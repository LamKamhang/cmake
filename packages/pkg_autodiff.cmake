include_guard()

# if autodiff::autodiff has been found
if (TARGET autodiff::autodiff)
  return()
endif()

message(STATUS "[package/autodiff]: autodiff::autodiff")

if (NOT DEFINED autodiff_TAG)
  if (NOT DEFINED autodiff_VERSION)
    set(autodiff_TAG "v1.0.1")
  else()
    set(autodiff_TAG v${autodiff_VERSION})
  endif()
endif()

require_package(autodiff "gh:autodiff/autodiff.git#${autodiff_TAG}"
  GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/autodiff.patch"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF")
