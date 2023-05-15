include_guard()

# if pybind11_json has been found
if (TARGET pybind11_json)
  return()
endif()

message(STATUS "[package/pybind11_json]: pybind11_json")

if (NOT DEFINED pybind11_json_TAG)
  if (NOT DEFINED pybind11_json_VERSION)
    set(pybind11_json_TAG "0.2.13")
  else()
    set(pybind11_json_TAG ${pybind11_json_VERSION})
  endif()
endif()

require_package(pybind11_json "gh:pybind/pybind11_json.git#${pybind11_json_TAG}"
  CMAKE_ARGS "-DBUILD_TESTS=OFF"
  CMAKE_ARGS "-DDOWNLOAD_GTEST=OFF"
)
