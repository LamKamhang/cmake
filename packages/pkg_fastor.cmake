include_guard()

# if Fastor::Fastor has been found
if (TARGET Fastor::Fastor)
  return()
endif()

message(STATUS "[package/Fastor]: Fastor::Fastor")

if (NOT ${fastor_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/Fastor] does not support version selection.")
endif()

if (NOT DEFINED fastor_TAG)
  set(fastor_TAG "origin/master")
endif()

lam_add_package_maybe_prebuild(
  "gh:romeric/Fastor#${fastor_TAG}"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
  # for user customize.
  ${fastor_USER_CMAKE_ARGS}
)

if (NOT TARGET Fastor::Fastor)
  add_library(Fastor::Fastor ALIAS Fastor)
endif()
