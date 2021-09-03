if (NOT DEFINED IGL_DIR)
  if (EXISTS ${PROJECT_SOURCE_DIR}/3rd/libigl)
    set(IGL_DIR ${PROJECT_SOURCE_DIR}/3rd/libigl)
  elseif(EXISTS ${PROJECT_SOURCE_DIR}/3rd/igl)
    set(IGL_DIR ${PROJECT_SOURCE_DIR}/3rd/igl)
  endif()
endif()

if (EXISTS ${IGL_DIR})
  message(STATUS "libigl find: ${IGL_DIR}")
  if (NOT TARGET igl)
    add_library(igl INTERFACE)
    target_include_directories(igl
      INTERFACE
      ${IGL_DIR}/include
      ${IGL_DIR}/external/libigl-imgui
      )
    if (NOT TARGET Eigen3::Eigen)
      require_package(Eigen3   "ssh://git@ryon.ren:10022/mirrors/eigen3.git"   "3.3.9")
    endif()
    if (USE_IGL_VIEWER)
      if (NOT TARGET glad)
        require_package(glad "git@github.com:LamKamhang/glad.git" "6ee1551")
      endif()
      if (NOT TARGET glfw)
        require_package(glfw3 "git@github.com:glfw/glfw.git" "33cd8b8")
      endif()
    endif()
    if (NOT TARGET Threads::Threads)
      find_package(Threads REQUIRED)
    endif()
    if (USE_IGL_VIEWER)
      target_link_libraries(igl INTERFACE glad glfw)
    endif()
    target_link_libraries(igl INTERFACE Eigen3::Eigen Threads::Threads)
  endif()
  set(igl_FOUND TRUE)
else()
  message(WARNING "libigl not found! please set {IGL_DIR} correctly!")
  set(igl_FOUND FALSE)
endif()
