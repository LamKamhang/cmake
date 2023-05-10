include_guard()

# if eventpp::eventpp has been found
if (TARGET eventpp::eventpp)
  return()
endif()

message(STATUS "[package/eventpp]: eventpp::eventpp")

set(eventpp_VERSION "origin/master" CACHE STRING "eventpp customized version")

require_package(eventpp "gh:wqking/eventpp#${eventpp_VERSION}"
  CMAKE_ARGS "-DEVENTPP_INSTALL=OFF"
)
