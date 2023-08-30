include_guard()

# if Catch2::Catch2 has been found
if (TARGET Catch2::Catch2)
  return()
endif()

message(STATUS "[package/Catch2]: Catch2::Catch2")
option(catch2_USE_CPP17_STRING_VIEW "Catch2 use cpp17 string_view" ON)
option(catch2_USE_CATCH_DISCOVER_TESTS "Catch2 enable catch_discover_tests for ctest" ON)

if (NOT DEFINED catch2_VERSION)
  set(catch2_VERSION "3.4.0")
endif()
if (NOT DEFINED catch2_TAG)
  set(catch2_TAG "v${catch2_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:catchorg/Catch2#${catch2_TAG}"
  OPTIONS
  "CATCH_BUILD_TESTING OFF"
  "CATCH_INSTALL_DOCS OFF"
  "CATCH_CONFIG_CPP17_STRING_VIEW ${catch2_USE_CPP17_STRING_VIEW}"
  # for user customize.
  ${catch2_USER_CMAKE_ARGS}
)

lam_check_prefer_prebuild(out catch2)
if (catch2_USE_CPP17_STRING_VIEW AND NOT out)
  target_compile_features(Catch2 PUBLIC cxx_std_17)
endif()
if (catch2_USE_CATCH_DISCOVER_TESTS)
  if (NOT out)
    lam_assert_defined(Catch2_SOURCE_DIR)
    list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
  endif()
  include(CTest)
  include(Catch)
endif()
