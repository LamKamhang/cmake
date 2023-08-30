include_guard()

# if msft_proxy has been found
if (TARGET msft_proxy)
  return()
endif()

message(STATUS "[package/proxy]: msft_proxy")


if (NOT DEFINED proxy_VERSION)
  set(proxy_VERSION "1.1.1")
endif()
if (NOT DEFINED proxy_TAG)
  set(proxy_TAG "${proxy_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:microsoft/proxy.git#${proxy_TAG}"
  CMAKE_ARGS "-DBUILD_TESTING=OFF")
