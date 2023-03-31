include_guard()

# if nanoflann::nanoflann has been found
if (TARGET nanoflann::nanoflann)
  return()
endif()

message(STATUS "[package/nanoflann]: nanoflann::nanoflann")

set(nanoflann_VERSION 1.4.3 CACHE STRING "nanoflann customized version")

require_package(nanoflann "gh:jlblancoc/nanoflann#v${nanoflann_VERSION}"
  CMAKE_ARGS "-DNANOFLANN_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DNANOFLANN_BUILD_BENCHMARKS=OFF"
  CMAKE_ARGS "-DNANOFLANN_BUILD_TESTS=OFF"
)
