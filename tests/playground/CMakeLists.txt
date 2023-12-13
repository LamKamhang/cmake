cmake_minimum_required(VERSION 3.16)

project(playground)

option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." OFF)
option(LAM_PACKAGE_PREFER_PREBUILT "prefer prebuilt mode(install and then find strategy)" OFF)
set(LAM_PACKAGE_FETCH_LATEST_TAG ON)
include(../../utility.cmake)

lam_use_deps(
  Eigen
  autodiff
  alglib
  benchmark
  Catch2
  #bgfx
  CLI11
  EnTT
  eventpp
  Fastor
  fmt
  csv-parser
  glad
  glbinding
  glfw
  glm
  happly
  imgui
  lbfgspp
  libigl
  libigl_imgui_fonts
  magic_enum
  msgpack
  nameof
  nanobind
  nanoflann
  nlohmann_json
  openmesh
  osqp
  # polyscope
  proxy
  pugixml
  pybind11
  pybind11_json
  spdlog
  spectra
  stb
  suitesparse
  tinyxml2
  tl-optional
  tl-expected
  # dealii
)

set(osqp_DIR ${osqp_INSTALL_DIR})
lam_use_deps(
  osqp-eigen
)

lam_assert_target_defined(
  Eigen3::Eigen
  autodiff::autodiff
  alglib
  benchmark::benchmark
  Catch2::Catch2
  CLI11::CLI11
  EnTT::EnTT
  eventpp::eventpp
  Fastor::Fastor
  fmt::fmt
  csv
  glad::glad
  glbinding::glbinding
  glfw::glfw
  glm::glm
  happly::happly
  imgui::imgui
  lbfgspp::lbfgspp
  igl::core
  igl::imgui_fonts
  magic_enum::magic_enum
  msgpack-cxx
  nameof::nameof
  nanoflann::nanoflann
  nlohmann_json::nlohmann_json
  OpenMeshCore
  osqp
  OsqpEigen::OsqpEigen
  # polyscope
  msft_proxy
  pugixml::pugixml
  pybind11::module
  pybind11_json
  spdlog::spdlog
  Spectra::Spectra
  stb::stb
  SuiteSparse::CHOLMOD
  tinyxml2::tinyxml2
  tl::expected
  tl::optional
)

# if (NOT COMMAND deal_ii_setup_target)
#   message(FATAL_ERROR "dealii not found.")
# endif()
