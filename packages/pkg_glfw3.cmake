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
option(glfw3_DEF_INCLUDE_NONE "define GLFW_INCLUDE_NONE" ON)

if (NOT DEFINED glfw3_VERSION)
  set(glfw3_VERSION "3.3.8")
endif()
if (NOT DEFINED glfw3_TAG)
  set(glfw3_TAG "${glfw3_VERSION}")
endif()

lam_check_prefer_prebuild(out glfw3)
lam_add_package_maybe_prebuild(
  "gh:glfw/glfw#${glfw3_TAG}"
  NAME glfw3
  CMAKE_ARGS "-DGLFW_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_DOCS=OFF"
  CMAKE_ARGS "-DGLFW_INSTALL=${out}"
  # for user customize.
  ${glfw3_USER_CUSTOMIZE_ARGS}
)

add_library(glfw::glfw ALIAS glfw)

if (${glfw3_DEF_INCLUDE_NONE})
  target_compile_definitions(glfw INTERFACE GLFW_INCLUDE_NONE)
endif()
