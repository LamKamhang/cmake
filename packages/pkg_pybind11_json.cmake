include_guard()

# if pybind11_json has been found.
if (TARGET pybind11_json)
  return()
endif()

message(STATUS "[package/pybind11_json]: pybind11_json")

set(pybind11_json_VERSION 0.2.13 CACHE STRING "pybind_json customized version")

require_package(pybind11_json "gh:pybind/pybind11_json.git#${pybind11_json_VERSION}"
  CMAKE_ARGS "-DBUILD_TESTS=OFF"
  CMAKE_ARGS "-DDOWNLOAD_GTEST=OFF"
)
