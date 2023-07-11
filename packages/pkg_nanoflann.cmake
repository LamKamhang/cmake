include_guard()

# if nanoflann::nanoflann has been found
if (TARGET nanoflann::nanoflann)
  return()
endif()

message(STATUS "[package/nanoflann]: nanoflann::nanoflann")

if (NOT DEFINED nanoflann_VERSION)
  set(nanoflann_VERSION "1.5.0")
endif()
if (NOT DEFINED nanoflann_TAG)
  set(nanoflann_TAG "v${nanoflann_VERSION}")
endif()

require_package(nanoflann "gh:jlblancoc/nanoflann#${nanoflann_TAG}"
  CMAKE_ARGS "-DNANOFLANN_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DNANOFLANN_BUILD_BENCHMARKS=OFF"
  CMAKE_ARGS "-DNANOFLANN_BUILD_EXAMPLES=OFF"
)
