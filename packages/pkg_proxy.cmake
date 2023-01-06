include_guard()

# if msft_proxy has been found.
if (TARGET msft_proxy)
  return()
endif()

message(STATUS "[package/proxy]: msft_proxy")

set(proxy_VERSION 1.1.1 CACHE STRING "proxy customized version")

require_package(proxy "gh:microsoft/proxy.git#${proxy_VERSION}"
  CMAKE_ARGS "-DBUILD_TESTING=OFF")
