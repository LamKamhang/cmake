cmake_minimum_required(VERSION 3.12)

project(cmake-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
# example1, same with find_package.
set(DEBUG_MODE TRUE)
require_package(OpenMP 4.2) # identical to find_package(OpenMP 4.2 REQUIRED)
require_package(Eigen3 3.0 NOT_REQUIRED) # identical to find_package(OpenMP 5.0)
require_package(Eigen3 3.0 REQUIRED)
require_package(Eigen3 3.6 NOT_REQUIRED)
require_package(Eigen3 3.4 DISABLE_FIND_PKG_FIRST
  DOWNLOAD_ONLY
  ENHANCE
  CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF;-DBUILD_TESTING=OFF"
  GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/eigen3.git"
  GIT_TAG "3.4.0"
  )
