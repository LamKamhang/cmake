cmake_minimum_required(VERSION 3.12)

project(cmake-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
# example1, same with find_package.
set(DEBUG_MODE TRUE)

add_package(spdlog "ssh://git@ryon.ren:10022/mirrors/spdlog.git" GIT_TAG "v1.9.2")
