include_guard()

# if OpenMeshCore has been found
if (TARGET OpenMeshCore)
  return()
endif()

message(STATUS "[package/OpenMesh]: OpenMeshCore")

if (NOT DEFINED openmesh_VERSION)
  set(openmesh_VERSION "9.0")
endif()
if (NOT DEFINED openmesh_TAG)
  set(openmesh_TAG "OpenMesh-${openmesh_VERSION}")
endif()

require_package(OpenMesh "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh.git#${openmesh_TAG}"
  CMAKE_ARGS "-DBUILD_APPS=OFF"
  CMAKE_ARGS "-DOPENMESH_DOCS=OFF"
)
