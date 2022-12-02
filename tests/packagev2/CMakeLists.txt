cmake_minimum_required(VERSION 3.6)

project(packagev2)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(core/cmake-core-assert)
include(core/cmake-core-fs)
include(core/cmake-core-package-v2)
set(DEBUG_MODE ON)
require_package(Eigen3)
require_package(spdlog "rom:gabime/spdlog#v1.10.0"
  DOWNLOAD_ONLY
  CMAKE_ARGS "-DSPDLOG_BUILD_EXAMPLE=OFF"
  )
# set(out ${CMAKE_SOURCE_DIR}/3rd)

# if (NOT IS_DIRECTORY ${out})
#   ERROR_MSG("not dir")
# endif()

# add_custom_target(fetch_all3rd)
# add_custom_target(build_all3rd)
# add_custom_target(install_all3rd)

# # 0. some global options.
# # local_package first.
# # local_package only.
# # import_as_subdir
# # 1. identical to find_package
# # package(name ...)
# # the same as find_package(name REQUIRED)
# # 2. add_subdirectory.
# # package(name URL)
# # package(name URI)
# #
# # require_package()
# # check add package.
# function(add_package name)
#   register_package(${name} "url" FLAGS)
#   add_dependencies(fetc)
# endfunction()
