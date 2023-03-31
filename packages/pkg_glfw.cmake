include_guard()

# if glfw has been found.
if (TARGET glfw::glfw)
  return()
endif()
if (TARGET glfw)
  add_library(glfw::glfw ALIAS glfw)
  return()
endif()

message(STATUS "[package/glfw]: glfw::glfw")

set(glfw_VERSION 3.3.8 CACHE STRING "glfw customized version.")

enable_language(C)

require_package(glfw3 "gh:glfw/glfw#${glfw_VERSION}"
  CMAKE_ARGS "-DGLFW_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_DOCS=OFF"
  )
add_library(glfw::glfw ALIAS glfw)
