include_guard()

message(STATUS "[package/Catch2]: Catch2::Catch2")

option(CATCH2_USE_CPP17_STRING_VIEW "Catch2 use cpp17 string_view" ON)
option(CATCH2_USE_CATCH_DISCOVER_TESTS "Catch2 enable catch_discover_tests for ctest" ON)

if(CATCH2_USE_CPP17_STRING_VIEW)
  require_package(Catch2 "gh:catchorg/Catch2#v3.2.1"
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/catch2.std17.patch"
    CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
    CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF"
    CMAKE_ARGS "-DCATCH_CONFIG_CPP17_STRING_VIEW=ON")
else()
  require_package(Catch2 "gh:catchorg/Catch2#v3.2.1"
    CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
    CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF")
endif()

# for catch_discover_tests
if (CATCH2_USE_CATCH_DISCOVER_TESTS)
  include(Catch)
endif()
