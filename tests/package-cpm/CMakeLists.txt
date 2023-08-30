cmake_minimum_required(VERSION 3.6)

project(package-cpm)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
set(DEBUG_MODE True)

require_package("gl:libeigen/eigen#3.4.0"
  NAME Eigen3
  GIT_PATCH eigen3.cholmod.patch
  CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
)
