include_guard()

# if tl::expected has been found
if (TARGET tl::expected)
  return()
endif()

message(STATUS "[package/tl-expected]: tl::expected")


if (NOT DEFINED tl-expected_VERSION)
  set(tl-expected_VERSION "1.1.0")
endif()
if (NOT DEFINED tl-expected_TAG)
  set(tl-expected_TAG "v${tl-expected_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:TartanLlama/expected#${tl-expected_TAG}"
  NAME tl-expected
  CMAKE_ARGS "-DEXPECTED_BUILD_PACKAGE=OFF"
  CMAKE_ARGS "-DEXPECTED_BUILD_TESTS=OFF"
)
