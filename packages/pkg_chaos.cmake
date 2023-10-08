include_guard()

# if chaos::chaos has been found
if(TARGET chaos::chaos)
  return()
endif()

message(STATUS "[package/chaos]: chaos::chaos")

if(NOT DEFINED chaos_VERSION)
  set(chaos_VERSION "0.2.0")
endif()
if(NOT DEFINED chaos_TAG)
  set(chaos_TAG "v${chaos_VERSION}")
endif()

lam_add_package_maybe_prebuilt(
  chaos "gh:suitechaos#${chaos_TAG}" NAME chaos
  OPTIONS
  "CHAOS_BUILD_EXAMPLES OFF"
  "CHAOS_BUILD_DOCS OFF"
  "CHAOS_BUILD_TESTS OFF"
  "CHAOS_BUILD_BENCHMARKS OFF"
  # for user customize.
  ${chaos_USER_CUSTOM_ARGS})
