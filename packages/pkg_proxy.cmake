include_guard()

message(STATUS "[package/proxy]: msft_proxy")

require_package(proxy "gh:microsoft/proxy.git#1.1.1"
  CMAKE_ARGS "-DBUILD_TESTING=OFF")
