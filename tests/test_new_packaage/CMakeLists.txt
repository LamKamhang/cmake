cmake_minimum_required(VERSION 3.14)

project(package-v2)

# option(LAM_ENABLE_ERROR_KEEP_GOING "enable lam_error() keep going" ON)

include(${CMAKE_CURRENT_LIST_DIR}/../../utility.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../../core/package_cpm_v2.cmake)

# lam_infer_version_from_tag(out "3.4.0")
# lam_infer_version_from_tag(out "v3.4.0")
# lam_infer_version_from_tag(out "version_1.2")
# lam_infer_version_from_tag(out "5.13.0-cmake.3")
# lam_infer_version_from_tag(out "5c46b9c")
# lam_infer_version_from_tag(out "csv-version-2-1.2.0")

# lam_get_name_from_uri(out "gl:libeigen/eigen.git#3.4.0")
# lam_get_name_from_uri(out "gl:libeigen/eigen.git#3.4.0")
# lam_get_name_from_uri(out "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh.git#OpenMesh-9.0")
# lam_get_name_from_uri(out "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh#OpenMesh-9.0")

# lam_split_uri("gh:libeigen/eigen#3.4")
# lam_split_uri("gh:libeigen/eigen#3.4.0@3.0")
# lam_split_uri("gh:libeigen/eigen@3.3.9#3.4.0@3.4.0")
# lam_split_uri("gh:libeigen/eigen@3.4.0#3.4.0")
# lam_split_uri("gh:libeigen/eigen#3.4.0@")
# lam_assert_defined(lam_pkg_url)
# lam_assert_defined(lam_pkg_version)
# lam_assert_defined(lam_pkg_tag)

# lam_extract_args_from_uri(out "gh:libeigen/eigen#3.4")
# lam_extract_args_from_uri(out "gh:libeigen/eigen#3.4.0@3.0")
# lam_extract_args_from_uri(out "gh:libeigen/eigen@3.3.9#3.4.0@3.4.0")
# lam_extract_args_from_uri(out "gh:libeigen/eigen@3.4.0#3.4.0")
# lam_extract_args_from_uri(out "gh:libeigen/eigen#3.4.0@")

# function(fucking_ l)
#   foreach(a ${l})
#     lam_debug("a: ${a}")
#   endforeach()
# endfunction()

# set(fuck_list "a b" "c d" "e f")
# fucking_("${fuck_list}")

# lam_require_package("gl:libeigen/eigen#3.4.0")
lam_add_package("gh:lamkamhang/glad#origin/master")
lam_add_package("gl:libeigen/eigen#3.4.0"
  NAME Eigen3
  GIT_PATCH "${_CMAKE_UTILITY_BASE_DIR}/packages/eigen/cholmod.patch"
  CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
  CMAKE_ARGS "-DBUILD_EIGEN_TEST=OFF"
  END_CMAKE_ARGS
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
  END_CMAKE_ARGS
)
lam_add_package("gh:catchorg/Catch2#v3.4.0"
  OPTIONS
  "CATCH_BUILD_TESTING OFF"
  "CATCH_INSTALL_DOCS OFF"
)
list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
include(CTest)
include(Catch)
