include_guard()

# if tl::optional has been found
if (TARGET tl::optional)
  return()
endif()

message(STATUS "[package/tl_optional]: tl::optional")


if (NOT DEFINED tl_optional_VERSION)
  set(tl_optional_VERSION "1.1.0")
endif()
if (NOT DEFINED tl_optional_TAG)
  set(tl_optional_TAG "v${tl_optional_VERSION}")
endif()

require_package("gh:TartanLlama/optional#${tl_optional_TAG}"
  NAME tl_optional
  CMAKE_ARGS "-DOPTIONAL_BUILD_PACKAGE=OFF"
  CMAKE_ARGS "-DOPTIONAL_BUILD_TESTS=OFF"
)
