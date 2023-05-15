include_guard()

# if Eigen3::Eigen has been found
if (TARGET Eigen3::Eigen)
  return()
endif()

message(STATUS "[package/Eigen3]: Eigen3::Eigen")
option(eigen_APPLY_CHOLMOD_PATCH "Apply cholmod patch for eigen" ON)

if (NOT DEFINED eigen_VERSION)
  set(eigen_VERSION "3.4.0")
endif()
if (NOT DEFINED eigen_TAG)
  set(eigen_TAG "${eigen_VERSION}")
endif()

if(eigen_APPLY_CHOLMOD_PATCH)
  require_package(Eigen3 "gl:libeigen/eigen#${eigen_TAG}"
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/eigen3.cholmod.patch"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
else()
  require_package(Eigen3 "gl:libeigen/eigen#${eigen_TAG}"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
endif()
