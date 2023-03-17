include_guard()

# if Catch2::Catch2 has been found.
if (TARGET Catch2::Catch2)
  return ()
endif()

message(STATUS "[package/Catch2]: Catch2::Catch2")

option(catch2_USE_CPP17_STRING_VIEW "Catch2 use cpp17 string_view" ON)
option(catch2_USE_CATCH_DISCOVER_TESTS "Catch2 enable catch_discover_tests for ctest" ON)
set(catch2_VERSION 3.2.1 CACHE STRING "Catch2 customized version")

if(catch2_USE_CPP17_STRING_VIEW)
  require_package(Catch2 "gh:catchorg/Catch2#v${catch2_VERSION}"
    CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
    CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF"
    CMAKE_ARGS "-DCATCH_CONFIG_CPP17_STRING_VIEW=ON")
  target_compile_features(Catch2 PUBLIC cxx_std_17)
else()
  require_package(Catch2 "gh:catchorg/Catch2#v${catch2_VERSION}"
    CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
    CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF")
endif()

# for catch_discover_tests
if (catch2_USE_CATCH_DISCOVER_TESTS)
  list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
  include(CTest)
  include(Catch)
endif()
