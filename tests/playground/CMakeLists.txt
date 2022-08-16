cmake_minimum_required(VERSION 3.12)

project(require-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
set(DEBUG_MODE True)

# configure_extproj(spdlog
#   GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/spdlog.git"
#   GIT_TAG "v1.9.2")

# update_extproj(spdlog)
# set(glfw3_ROOT "/home/kk/3rd-bkp")
# do_find_package(glfw3 REQUIRED)
# set(autodiff_ROOT "/home/kk/3rd-bkp")
# do_find_package(autodiff REQUIRED)
# do_find_package(Spectra REQUIRED)
# do_find_package(pybind11 REQUIRED)
# # prepare_arguments(find_args EP_args Eigen3 GLOBAL HINTS good here NO_PACKAGE_ROOT_PATH)
# # gt_add_package(autodiff "ssh://git@ryon.ren:10022/mirrors/autodiff.git" GIT_TAG "v0.6.8"
# #   CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
# #   CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
# #   CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
# #   CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF"
# #   )
# require_package(Eigen3 VERSION 3.4 REQUIRED)

# DEBUG_MSG("--1")
# require_package(Eigen3 3.4.0
#   FIND_FIRST_OFF
#   GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/eigen3.git"
#   GIT_TAG "3.4.0")
# if (TARGET Eigen3::Eigen)
#   DEBUG_MSG("YES")
# endif()
# DEBUG_MSG("--2")
# require_package(spdlog 1.10
#   FIND_FIRST_OFF
#   IMPORT_AS_SUBDIR
#   GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/spdlog.git"
#   GIT_TAG "v1.10.0"
#   )
# if (TARGET spdlog::spdlog)
#   DEBUG_MSG("PASSED")
# endif()

# is_url(out "https://fff")
# if (out)
#   DEBUG_MSG("good1")
# endif()
# is_url(out "git@github.com")
# if (out)
#   DEBUG_MSG("good2")
# endif()
# is_url(out GIT_REPOSITORY)
# if (out)
#   DEBUG_MSG("good3")
# endif()
# infer_args_from_uri(out "rom:spdlog/spdlog#v1.2@1.0")
# infer_args_from_uri(out "rom:Catch2#v1.9")
# infer_args_from_uri(out "gh:spdlog/spdlog#v1.2@1.0")
# infer_args_from_uri(out "gh:spdlog/spdlog#v1.2")
# infer_args_from_uri(out "gh:spdlog/spdlog#@1.0")
# infer_args_from_uri(out "gh:spdlog/spdlog#asdfab")
# infer_args_from_uri(out "gh:spdlog/spdlog#1dfa")
# infer_args_from_uri(out "ssh://git@ryon.ren:10022/mirrors/libigl.git")
# infer_args_from_uri(out "git@github.com:osqp/osqp.git")
# infer_args_from_uri(out "https://github.com/Yixin-Hu/TetWild.git")
# infer_args_from_uri(out "https://github.com/CPPAlliance/url/archive/refs/tags/static-pool.zip")
# infer_args_from_uri(out "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh")
infer_args_from_uri(spdlog "rom:spdlog/spdlog#v1.2@")
infer_args_from_uri(spdlog "rom:spdlog/spdlog#v1.2")
