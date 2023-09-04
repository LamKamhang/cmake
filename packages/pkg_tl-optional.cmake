include_guard()

# if tl::optional has been found
if (TARGET tl::optional)
  return()
endif()

message(STATUS "[package/tl-optional]: tl::optional")


if (NOT DEFINED tl-optional_VERSION)
  set(tl-optional_VERSION "1.1.0")
endif()
if (NOT DEFINED tl-optional_TAG)
  set(tl-optional_TAG "v${tl-optional_VERSION}")
endif()

lam_add_package_maybe_prebuild(tl-optional
  "gh:TartanLlama/optional#${tl-optional_TAG}"
  NAME tl-optional
  CMAKE_ARGS "-DOPTIONAL_BUILD_PACKAGE=OFF"
  CMAKE_ARGS "-DOPTIONAL_BUILD_TESTS=OFF"
  # for user customize.
  ${tl-optional_USER_CUSTOM_ARGS}
)
