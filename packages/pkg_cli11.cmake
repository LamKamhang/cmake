include_guard()

# if CLI11::CLI11 has been found.
if (TARGET CLI11::CLI11)
  return()
endif()

message(STATUS "[package/CLI11]: CLI11::CLI11")

set(cli11_VERSION 2.3.1 CACHE STRING "CLI11 customized version")

require_package(CLI11 "gh:CLIUtils/CLI11#v${cli11_VERSION}"
  CMAKE_ARGS "-DCLI11_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_DOCS=OFF")
