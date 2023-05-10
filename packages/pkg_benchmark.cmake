include_guard()

# if benchmark::benchmark has been found
if (TARGET benchmark::benchmark)
  return()
endif()

message(STATUS "[package/benchmark]: benchmark::benchmark")

set(benchmark_VERSION 1.8.0 CACHE STRING "benchmark customized version")

require_package(benchmark "gh:google/benchmark#v${benchmark_VERSION}"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_TESTING=OFF"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_INSTALL=OFF"
  CMAKE_ARGS "-DBENCHMARK_INSTALL_DOCS=OFF"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF"
  CMAKE_ARGS "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
)
