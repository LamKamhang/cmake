cmake_minimum_required(VERSION 3.14)

project(test_package)

include(utility)
lam_add_prebuild_package("gl:libeigen/eigen#3.4.0"
  NAME Eigen3
  CMAKE_ARGS
  "-DEIGEN_BUILD_DOC=OFF"
  "-DBUILD_TESTING=OFF"
)
lam_assert_target_defined(Eigen3::Eigen)
