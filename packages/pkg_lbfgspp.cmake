include_guard()

# if lbfgspp has been found
if (TARGET lbfgspp::lbfgspp)
  return()
endif()
if (TARGET lbfgspp)
  add_library(lbfgspp::lbfgspp ALIAS lbfgspp)
  return()
endif()

message(STATUS "[package/lbfgspp]: lbfgspp")

if (NOT DEFINED lbfgspp_VERSION)
  set(lbfgspp_VERSION "0.3.0")
endif()
if (NOT DEFINED lbfgspp_TAG)
  set(lbfgspp_TAG "v${lbfgspp_VERSION}")
endif()

lam_add_package("gh:yixuan/LBFGSpp#${lbfgspp_TAG}"
  NAME lbfgspp
  GIT_SHALLOW OFF
)
add_library(lbfgspp::lbfgspp ALIAS lbfgspp)
