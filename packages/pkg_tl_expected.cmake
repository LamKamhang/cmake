include_guard()

# if tl::expected has been found
if (TARGET tl::expected)
  return()
endif()

message(STATUS "[package/tl_expected]: tl::expected")


if (NOT DEFINED tl_expected_VERSION)
  set(tl_expected_VERSION "1.1.0")
endif()
if (NOT DEFINED tl_expected_TAG)
  set(tl_expected_TAG "v${tl_expected_VERSION}")
endif()

require_package("gh:TartanLlama/expected#${tl_expected_TAG}"
  NAME tl_expected
  CMAKE_ARGS "-DEXPECTED_BUILD_PACKAGE=OFF"
  CMAKE_ARGS "-DEXPECTED_BUILD_TESTS=OFF"
)
