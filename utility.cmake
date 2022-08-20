cmake_minimum_required(VERSION 3.12)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/packages)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/core)

include(cmake-core-assert)
include(cmake-core-target-helper)
include(cmake-core-fs)
include(cmake-core-package)
