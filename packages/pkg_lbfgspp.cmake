include_guard()

if (TARGET lbfgspp)
  return()
endif()

message(STATUS "[package/lbfgspp]: lbfgspp")

set(lbfgspp_TAG 563106b CACHE STRING "lbfgspp git tag")

require_package(lbfgspp "gh:yixuan/LBFGSpp#${lbfgspp_TAG}@")
