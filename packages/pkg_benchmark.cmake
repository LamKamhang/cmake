include_guard()

# if benchmark::benchmark has been found
if (TARGET benchmark::benchmark)
  return()
endif()

message(STATUS "[package/benchmark]: benchmark::benchmark")

if (NOT DEFINED benchmark_VERSION)
  set(benchmark_VERSION "1.8.0")
endif()
if (NOT DEFINED benchmark_TAG)
  set(benchmark_TAG "v${benchmark_VERSION}")
endif()

require_package("gh:google/benchmark#${benchmark_TAG}"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_TESTING=OFF"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_INSTALL=OFF"
  CMAKE_ARGS "-DBENCHMARK_INSTALL_DOCS=OFF"
  CMAKE_ARGS "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF"
  CMAKE_ARGS "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
)
