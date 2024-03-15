include_guard()

# if Backward::Interface has been found
if (TARGET Backward::Interface)
  return()
endif()

message(STATUS "[package/Backward]: Backward::Interface")

if (NOT ${backward_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/Backward] does not support version selection.")
endif()

if (NOT DEFINED backward_TAG)
  set(backward_TAG "51f0700")
endif()

lam_check_prefer_prebuilt(out backward)
lam_add_package_maybe_prebuilt(backward
  "gh:bombela/backward-cpp#${backward_TAG}"
  NAME Backward
  CMAKE_PARGS
  "-DSTACK_DETAILS_DW=ON"
  "-DBACKWARD_TESTS=OFF"
  # for user customize.
  ${backward_USER_CUSTOM_ARGS}
)
