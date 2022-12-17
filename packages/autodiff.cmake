include_guard()

message(STATUS "[package/autodiff]: autodiff::autodiff")

require_package(autodiff "gh:autodiff/autodiff.git#v0.6.12"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF")
