include_guard()

# if benchmark::benchmark has been found
if (TARGET benchmark::benchmark)
  return()
endif()

message(STATUS "[package/benchmark]: benchmark::benchmark")

if (NOT DEFINED benchmark_VERSION)
  set(benchmark_VERSION "1.8.3")
endif()
if (NOT DEFINED benchmark_TAG)
  set(benchmark_TAG "v${benchmark_VERSION}")
endif()

lam_check_prefer_prebuilt(out benchmark)

lam_add_package_maybe_prebuilt(benchmark
  "gh:google/benchmark#${benchmark_TAG}"
  CMAKE_ARGS
  "-DBENCHMARK_ENABLE_TESTING=OFF"
  "-DBENCHMARK_INSTALL_DOCS=OFF"
  "-DBENCHMARK_ENABLE_LTO=ON"
  "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF"
  "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
  "-DBENCHMARK_ENABLE_INSTALL=${out}"
  # for user customize.
  ${benchmark_USER_CUSTOM_ARGS}
)
