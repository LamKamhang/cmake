include_guard()

# if spdlog::spdlog has been found
if (TARGET spdlog::spdlog)
  return()
endif()

message(STATUS "[package/spdlog]: spdlog::spdlog")

if (NOT DEFINED spdlog_TAG)
  if (NOT DEFINED spdlog_VERSION)
    set(spdlog_TAG "v1.10.0")
  else()
    set(spdlog_TAG v${spdlog_VERSION})
  endif()
endif()

require_package(spdlog "gh:gabime/spdlog#${spdlog_TAG}"
  CMAKE_ARGS "-DSPDLOG_BUILD_EXAMPLE=OFF")
