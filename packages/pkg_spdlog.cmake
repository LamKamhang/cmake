include_guard()

# if spdlog::spdlog has been found
if (TARGET spdlog::spdlog)
  return()
endif()

message(STATUS "[package/spdlog]: spdlog::spdlog")

if (NOT DEFINED spdlog_VERSION)
  set(spdlog_VERSION "1.12.0")
endif()
if (NOT DEFINED spdlog_TAG)
  set(spdlog_TAG "v${spdlog_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:gabime/spdlog#${spdlog_TAG}"
  CMAKE_ARGS "-DSPDLOG_BUILD_EXAMPLE=OFF"
)
