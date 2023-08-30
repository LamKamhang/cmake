cmake_minimum_required(VERSION 3.16)

project(test_dep)
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
option(imgui_USE_DOCKING "Enable Docking Feature" OFF)
declare_pkg_deps(
  alglib
  autodiff
  benchmark
  catch2
  cli11
  csv-parser
  eigen
  entt
  eventpp
  fastor
  fmt
  glad
  glfw
  glm
  happly
  imgui
  lbfgspp
  libigl
  libigl_imgui_fonts
  magic_enum
  nameof
  nanobind
  nanoflann
  nlohmann_json
  openmesh
  osqp
  osqp-eigen
  proxy
  pybind11
  pybind11_json
  spdlog
  spectra
  stb
  suitesparse
)
