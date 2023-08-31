include_guard()

# if VTK::IOLegacy has been found
if (TARGET VTK::IOLegacy)
  return()
endif()

message(STATUS "[package/VTK]: VTK::IOLegacy")


if (NOT DEFINED vtk_VERSION)
  set(vtk_VERSION "9.2.6")
endif()
if (NOT DEFINED vtk_TAG)
  set(vtk_TAG "v${vtk_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:Kitware/VTK#${vtk_TAG}"
  NAME VTK
  OPTIONS
  "VTK_ENABLE_LOGGING OFF"
  "VTK_ENABLE_REMOTE_MODULES OFF"
  # for user customize.
  ${vtk_USER_CMAKE_ARGS}
)
