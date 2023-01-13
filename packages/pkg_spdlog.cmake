include_guard()

# if spdlog::spdlog has been found.
if (TARGET spdlog::spdlog)
  return()
endif()

message(STATUS "[package/spdlog]: spdlog::spdlog")

set(spdlog_VERSION 1.10.0 CACHE STRING "spdlog customized version.")

require_package(spdlog "gh:gabime/spdlog#v${spdlog_VERSION}"
  CMAKE_ARGS "-DSPDLOG_BUILD_EXAMPLE=OFF")