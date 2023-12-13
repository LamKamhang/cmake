cmake_minimum_required(VERSION 3.16)

project(playground)

option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." OFF)
option(LAM_PACKAGE_PREFER_PREBUILT "prefer prebuilt mode(install and then find strategy)" ON)

include(../../utility.cmake)

lam_push_variable(test 0)
lam_status("current: ${test}")
lam_push_variable(test 1)
lam_status("current: ${test}")
lam_push_variable(test 2)
lam_status("current: ${test}")
lam_status("stack: ${__test_STACK}")
lam_pop_variable(test)
lam_status("current: ${test}")
lam_status("stack: ${__test_STACK}")
#set(LAM_PACKAGE_OVERRIDE_FIND_PACKAGE OFF)
lam_use_deps(
  ceres-solver
  chaos@0.3.1)
