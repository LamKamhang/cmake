cmake_minimum_required(VERSION 3.12)

project(cmake-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

require_package(Eigen3 EXACT 3.3.0)
require_package(OpenMP REQUIRED REQUIRED 4.2)
