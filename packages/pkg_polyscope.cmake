include_guard()

# if polyscope has beed found.
if (TARGET polyscope::polyscope)
  return()
endif()
if (TARGET polyscope)
  add_library(polyscope::polyscope ALIAS polyscope)
  return()
endif()

message(STATUS "[package/polyscope]: polyscope::polyscope")
set(polyscope_VERSION 1.3.0 CACHE STRING "polyscope customized version.")

require_package(polyscope "gh:nmwsharp/polyscope#v${polyscope_VERSION}")
