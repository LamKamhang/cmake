include_guard()

# if polyscope has been found
if (TARGET polyscope)
  return()
endif()

message(STATUS "[package/polyscope]: polyscope")


if (NOT DEFINED polyscope_VERSION)
  set(polyscope_VERSION "1.3.0")
endif()
if (NOT DEFINED polyscope_TAG)
  set(polyscope_TAG "v${polyscope_VERSION}")
endif()

lam_add_package(
  "gh:nmwsharp/polyscope#${polyscope_TAG}")
