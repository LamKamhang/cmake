include_guard()

# if pybind11::module has been found
if (TARGET pybind11::module)
  return()
endif()

message(STATUS "[package/pybind11]: pybind11::module")

if (NOT DEFINED pybind11_TAG)
  if (NOT DEFINED pybind11_VERSION)
    set(pybind11_TAG "v2.10.1")
  else()
    set(pybind11_TAG v${pybind11_VERSION})
  endif()
endif()

require_package(pybind11 "gh:pybind/pybind11#${pybind11_TAG}"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF")
