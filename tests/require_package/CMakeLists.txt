cmake_minimum_required(VERSION 3.12)

project(require-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
# example1, same with find_package.
set(DEBUG_MODE TRUE)
require_package(Catch2 DISABLE_FIND_PKG_FIRST EP_ARGS
  GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/Catch2.git"  GIT_TAG "v2.13.7")

# example1: like find_package.
require_package(Eigen3 REQUIRED)

# example2: import as submodule
# first find the source.
require_package(Eigen3 IMPORT_AS_SUBMODULE)

# function to register package.
# DO NOT execute_process!
configure_package(Eigen3
  # Provide some easy preset.
  # like: DOWNLOAD_ONLY
  # Configure dir structure
  # Some ExternalProject_Add args.
  # Out_VAL:
  # EP_SOURCE_DIR, EP_CONFIGURE_DIR,
  )

# run the default target.
install_package(Eigen3)
# run update and patch.
update_package(Eigen3)
# run build
build_package(Eigen3)
