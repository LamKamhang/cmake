include_guard()

# if Eigen3::Eigen has been found.
if (TARGET Eigen3::Eigen)
  return()
endif()

message(STATUS "[package/Eigen3]: Eigen3::Eigen")

set(EIGEN_VERSION 3.4.0 CACHE STRING "eigen customized version")
option(EIGEN_APPLY_CHOLMOD_PATCH "Apply cholmod patch for eigen3" ON)

if(EIGEN_APPLY_CHOLMOD_PATCH)
  require_package(Eigen3 "gl:libeigen/eigen#${EIGEN_VERSION}" LOCAL_FIRST_OFF
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/eigen3.cholmod.patch"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
else()
  require_package(Eigen3 "gl:libeigen/eigen#${EIGEN_VERSION}"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
endif()
