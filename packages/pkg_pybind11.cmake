include_guard()

message(STATUS "[package/pybind11]: pybind11::module")

require_package(pybind11 "gh:pybind/pybind11#v2.10.1"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF")
