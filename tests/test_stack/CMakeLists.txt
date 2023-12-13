cmake_minimum_required(VERSION 3.16)

project(playground)

option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." OFF)

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
lam_use_deps(chaos@0.3.2)
