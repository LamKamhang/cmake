cmake_minimum_required(VERSION 3.12)

project(require-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
set(DEBUG_MODE True)

configure_extproj(spdlog
  GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/spdlog.git"
  GIT_TAG "v1.9.2")
