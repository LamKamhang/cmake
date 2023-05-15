include_guard()

# if CLI11::CLI11 has been found
if (TARGET CLI11::CLI11)
  return()
endif()

message(STATUS "[package/CLI11]: CLI11::CLI11")

if (NOT DEFINED cli11_TAG)
  if (NOT DEFINED cli11_VERSION)
    set(cli11_TAG v2.3.1)
  else()
    set(cli11_TAG v${cli11_VERSION})
  endif()
endif()

require_package(CLI11 "gh:CLIUtils/CLI11#${cli11_TAG}"
  CMAKE_ARGS "-DCLI11_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_DOCS=OFF")
