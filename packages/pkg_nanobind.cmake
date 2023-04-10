include_guard()

message(STATUS "[package/nanobind]")

set(nanobind_VERSION 1.1.1 CACHE STRING "nanobind customized version")

require_package(nanobind "gh:wjakob/nanobind#v${nanobind_VERSION}"
  CMAKE_ARGS "-DNB_TEST=OFF"
  CMAKE_ARGS "-DNB_TEST_STABLE_ABI=OFF"
  CMAKE_ARGS "-DNB_TEST_SHARED_BUILD=OFF"
)
