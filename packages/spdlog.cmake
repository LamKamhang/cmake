include_guard()

message(STATUS "[package/spdlog]: spdlog::spdlog")

require_package(spdlog "gh:gabime/spdlog#v1.10.0"
  CMAKE_ARGS "-DSPDLOG_BUILD_EXAMPLE=OFF")