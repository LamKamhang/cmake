include_guard()

# if VTK::IOLegacy has been found
if (TARGET VTK::IOLegacy)
  return()
endif()

message(STATUS "[package/VTK]: VTK::IOLegacy")

set(vtk_DEFAULT_OPTIONS_PRESET io-only CACHE STRING "preset for vtk cofigure options")
set_property(CACHE vtk_DEFAULT_OPTIONS_PRESET PROPERTY STRINGS
  default
  io-only
)

include(${CMAKE_CURRENT_LIST_DIR}/${vtk_DEFAULT_OPTIONS_PRESET}.options.cmake)

if (NOT DEFINED vtk_VERSION)
  set(vtk_VERSION "9.2.6")
endif()
if (NOT DEFINED vtk_TAG)
  set(vtk_TAG "v${vtk_VERSION}")
endif()

lam_add_package_maybe_prebuilt(vtk
  "gh:Kitware/VTK#${vtk_TAG}"
  NAME VTK
  OPTIONS
  "BUILD_SHARED_LIBS OFF"
  ${vtk_DEFAULT_OPTIONS}
  # for user customize.
  ${vtk_USER_CUSTOM_ARGS}
)

# for vtkio-all-in-one.
if (NOT TARGET vtk::vtkio-all-in-one)
  if (NOT TARGET vtkio-all-in-one)
    add_library(vtkio-all-in-one INTERFACE)
    target_link_libraries(vtkio-all-in-one INTERFACE
      VTK::IOLegacy
      # TODO. list some necessary libs here.
    )
  endif()
  add_library(vtk::vtkio-all-in-one ALIAS vtkio-all-in-one)
endif()
