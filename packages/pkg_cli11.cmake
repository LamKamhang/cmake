include_guard()

# if CLI11::CLI11 has been found
if (TARGET CLI11::CLI11)
  return()
endif()

message(STATUS "[package/CLI11]: CLI11::CLI11")

if (NOT DEFINED cli11_VERSION)
  set(cli11_VERSION "2.3.2")
endif()
if (NOT DEFINED cli11_TAG)
  set(cli11_TAG "v${cli11_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:CLIUtils/CLI11#${cli11_TAG}"
  NAME CLI11
  OPTIONS
  "CLI11_BUILD_EXAMPLES OFF"
  "CLI11_BUILD_TESTS OFF"
  "CLI11_BUILD_DOCS OFF"
  # for user customize.
  ${cli11_USER_CUSTOMIZE_ARGS}
)
