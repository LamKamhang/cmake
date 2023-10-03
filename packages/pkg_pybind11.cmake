include_guard()

# if pybind11::module has been found
if (TARGET pybind11::module)
  return()
endif()

message(STATUS "[package/pybind11]: pybind11::module")

if (NOT DEFINED pybind11_VERSION)
  set(pybind11_VERSION "2.11.1")
endif()
if (NOT DEFINED pybind11_TAG)
  set(pybind11_TAG "v${pybind11_VERSION}")
endif()

# suppress the warning for pybind11.
# use new way to find python components
find_package(Python COMPONENTS Interpreter Development.Module REQUIRED)
lam_add_package_maybe_prebuild(pybind11
  "gh:pybind/pybind11#${pybind11_TAG}"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF"
  # for user customize.
  ${pybind11_USER_CUSTOM_ARGS}
)
