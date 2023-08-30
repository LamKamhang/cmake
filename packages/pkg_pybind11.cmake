include_guard()

# if pybind11::module has been found
if (TARGET pybind11::module)
  return()
endif()

message(STATUS "[package/pybind11]: pybind11::module")

if (NOT DEFINED pybind11_VERSION)
  set(pybind11_VERSION "2.10.4")
endif()
if (NOT DEFINED pybind11_TAG)
  set(pybind11_TAG "v${pybind11_VERSION}")
endif()

lam_add_package(
  "gh:pybind/pybind11#${pybind11_TAG}"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF")
