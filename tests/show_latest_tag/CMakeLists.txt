cmake_minimum_required(VERSION 3.16)

project(playground)

option(LAM_PACKAGE_ENABLE_TRY_FIND "enable find_package first before download." OFF)
option(LAM_PACKAGE_PREFER_PREBUILT "prefer prebuilt mode(install and then find strategy)" OFF)

include(../../utility.cmake)

