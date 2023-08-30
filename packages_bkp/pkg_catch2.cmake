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

set(_args
  "gh:catchorg/Catch2#${catch2_TAG}"
  CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
  CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF"
)

if(catch2_USE_CPP17_STRING_VIEW)
  set(_args ${_args}
    CMAKE_ARGS "-DCATCH_CONFIG_CPP17_STRING_VIEW=ON"
  )
endif()

if (CHAOS_PACKAGE_PREFER_INSTALL_FIND)
  install_and_find_package(${_args})
else()
  require_package(${_args})
  if (catch2_USE_CATCH_DISCOVER_TESTS)
    list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
  endif()
  if (catch2_USE_CPP17_STRING_VIEW)
    target_compile_features(Catch2 PUBLIC cxx_std_17)
  endif()
endif()

# for catch_discover_tests
if (catch2_USE_CATCH_DISCOVER_TESTS)
  include(CTest)
  include(Catch)
endif()
