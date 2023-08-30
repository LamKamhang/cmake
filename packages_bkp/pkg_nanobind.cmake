include_guard()

# if nanobind has been found
if (TARGET nanobind)
  return()
endif()

message(STATUS "[package/nanobind]: nanobind")


if (NOT DEFINED nanobind_VERSION)
  set(nanobind_VERSION "1.2.0")
endif()
if (NOT DEFINED nanobind_TAG)
  set(nanobind_TAG "v${nanobind_VERSION}")
endif()

find_package(Python 3.8 COMPONENTS Interpreter Development.Module REQUIRED)
require_package("gh:wjakob/nanobind#${nanobind_TAG}"
  CMAKE_ARGS "-DNB_TEST=OFF"
  CMAKE_ARGS "-DNB_TEST_STABLE_ABI=OFF"
  CMAKE_ARGS "-DNB_TEST_SHARED_BUILD=OFF"
)
