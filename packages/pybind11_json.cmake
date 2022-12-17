include_guard()

message(STATUS "[package/pybind11_json]: pybind11_json")

require_package(pybind11_json "gh:pybind/pybind11_json.git#0.2.13"
  CMAKE_ARGS "-DBUILD_TESTS=OFF"
  CMAKE_ARGS "-DDOWNLOAD_GTEST=OFF"
)
