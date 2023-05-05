include_guard()

# if OpenMesh:: has been found
if (TARGET OpenMeshCore)
  return()
endif()

message(STATUS "[package/OpenMesh]: OpenMeshCore OpenMeshTools")

set(OpenMesh_VERSION 9.0 CACHE STRING "OpenMesh customized version")

require_package(OpenMesh "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh.git#OpenMesh-${OpenMesh_VERSION}"
  CMAKE_ARGS "-DBUILD_APPS=OFF"
  CMAKE_ARGS "-DOPENMESH_DOCS=OFF"
)
