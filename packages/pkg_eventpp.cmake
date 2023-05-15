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

require_package(eventpp "gh:wqking/eventpp#${eventpp_TAG}"
  CMAKE_ARGS "-DEVENTPP_INSTALL=OFF"
)
