include_guard()

message(STATUS "[package/Eigen3]: Eigen3::Eigen")

option(EIGEN_APPLY_CHOLMOD_PATCH "Apply cholmod patch for eigen3" ON)

if(EIGEN_APPLY_CHOLMOD_PATCH)
  require_package(Eigen3 "gl:libeigen/eigen#3.4.0" LOCAL_FIRST_OFF
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/eigen3.cholmod.patch"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
else()
  require_package(Eigen3 "gl:libeigen/eigen#3.4.0"
    CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF")
endif()
