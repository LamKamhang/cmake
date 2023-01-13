include_guard()

# if autodiff::autodiff has been found.
if (TARGET autodiff::autodiff)
  return()
endif()

message(STATUS "[package/autodiff]: autodiff::autodiff")

set(autodiff_VERSION 0.6.12 CACHE STRING "autodiff customized version")

require_package(autodiff "gh:autodiff/autodiff.git#v${autodiff_VERSION}"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF")