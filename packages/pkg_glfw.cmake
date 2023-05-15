include_guard()

# if glfw::glfw has been found
if (TARGET glfw::glfw)
  return()
endif()
if (TARGET glfw)
  add_library(glfw::glfw ALIAS glfw)
  return()
endif()

message(STATUS "[package/glfw3]: glfw::glfw")
enable_language(C)

if (NOT DEFINED glfw_VERSION)
  set(glfw_VERSION "3.3.8")
endif()
if (NOT DEFINED glfw_TAG)
  set(glfw_TAG "${glfw_VERSION}")
endif()

require_package(glfw3 "gh:glfw/glfw#${glfw_TAG}"
  CMAKE_ARGS "-DGLFW_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_DOCS=OFF"
  CMAKE_ARGS "-DGLFW_INSTALL=OFF"
)
add_library(glfw::glfw ALIAS glfw)
