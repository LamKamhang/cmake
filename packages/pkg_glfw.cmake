include_guard()

# if glfw::glfw has been found
if (TARGET glfw::glfw)
  return()
endif()
if (TARGET glfw)
  add_library(glfw::glfw ALIAS glfw)
  return()
endif()

message(STATUS "[package/glfw]: glfw::glfw")

if (NOT DEFINED glfw_TAG)
  if (NOT DEFINED glfw_VERSION)
    set(glfw_TAG "3.3.8")
  else()
    set(glfw_TAG ${glfw_VERSION})
  endif()
endif()

enable_language(C)

require_package(glfw3 "gh:glfw/glfw#${glfw_TAG}"
  CMAKE_ARGS "-DGLFW_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_DOCS=OFF"
  CMAKE_ARGS "-DGLFW_INSTALL=OFF"
)
add_library(glfw::glfw ALIAS glfw)
