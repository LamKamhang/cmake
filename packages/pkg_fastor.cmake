include_guard()

# if Fastor::Fastor has been found
if (TARGET Fastor::Fastor)
  return()
endif()

message(STATUS "[package/Fastor]: Fastor::Fastor")

set(fastor_VERSION "origin/master" CACHE STRING "Fastor customized version")

require_package(Fastor "gh:romeric/Fastor#${fastor_VERSION}"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
)

if (NOT TARGET Fastor::Fastor)
  add_library(Fastor::Fastor ALIAS Fastor)
endif()
