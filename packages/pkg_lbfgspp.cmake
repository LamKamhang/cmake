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

if (NOT DEFINED lbfgspp_TAG)
  if (NOT DEFINED lbfgspp_VERSION)
    set(lbfgspp_TAG "0a32ccb@0.2.1") # v0.2.1 still not release.
  else()
    set(lbfgspp_TAG "v${lbfgspp_VERSION}")
  endif()
endif()

lam_add_package("gh:yixuan/LBFGSpp#${lbfgspp_TAG}"
  NAME lbfgspp
  GIT_SHALLOW OFF
)
add_library(lbfgspp::lbfgspp ALIAS lbfgspp)
