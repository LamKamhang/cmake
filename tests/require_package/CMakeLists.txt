cmake_minimum_required(VERSION 3.12)

project(require-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
# example1, same with find_package.
set(DEBUG_MODE TRUE)

# # example1: like find_package.
# require_package(spdlog 1.10.0
#   GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/spdlog.git"
#   GIT_TAG "v1.10.0")
# if (TARGET spdlog::spdlog)
#   DEBUG_MSG("PASSED")
# endif()

# example2: import as submodule
require_package(spdlog 1.10.0
  FIND_FIRST_OFF
  IMPORT_AS_SUBDIR
  GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/spdlog.git"
  GIT_TAG "v1.10.0"
  )

# if (TARGET spdlog::spdlog)
#   DEBUG_MSG("PASSED")
# endif()
