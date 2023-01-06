include_guard()

# if pybind11::module has been found
if (TARGET pybind11::module)
  return()
endif()

message(STATUS "[package/pybind11]: pybind11::module")

set(pybind11_VERSION 2.10.1 CACHE STRING "pybind11 customized version")

require_package(pybind11 "gh:pybind/pybind11#v${pybind11_VERSION}"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF")
