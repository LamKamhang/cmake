include_guard()

# if lbfgspp has been found
if (TARGET lbfgspp)
  return()
endif()

message(STATUS "[package/lbfgspp]: lbfgspp")

if (NOT DEFINED lbfgspp_TAG)
  if (NOT DEFINED lbfgspp_VERSION)
    set(lbfgspp_TAG "803e9fb@0.2.1") # v0.2.1 still not release.
  else()
    set(lbfgspp_TAG "v${lbfgspp_VERSION}")
  endif()
endif()

require_package("gh:yixuan/LBFGSpp#${lbfgspp_TAG}"
  NAME lbfgspp
)
