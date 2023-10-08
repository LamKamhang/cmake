include_guard()

# if eventpp::eventpp has been found
if (TARGET eventpp::eventpp)
  return()
endif()

message(STATUS "[package/eventpp]: eventpp::eventpp")

if (NOT ${eventpp_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/eventpp] does not support version selection.")
endif()

if (NOT DEFINED eventpp_TAG)
  set(eventpp_TAG "origin/master")
endif()

lam_check_prefer_prebuilt(out eventpp)
lam_add_package_maybe_prebuilt(eventpp
  "gh:wqking/eventpp#${eventpp_TAG}"
  NAME eventpp
  CMAKE_ARGS "-DEVENTPP_INSTALL=${out}"
  # for user customize.
  ${eventpp_USER_CUSTOM_ARGS}
)
