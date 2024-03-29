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
enable_language(C)
option(glfw_DEF_INCLUDE_NONE "define GLFW_INCLUDE_NONE" ON)

if (NOT DEFINED glfw_VERSION)
  set(glfw_VERSION "3.3.8")
endif()
if (NOT DEFINED glfw_TAG)
  set(glfw_TAG "${glfw_VERSION}")
endif()

lam_check_prefer_prebuilt(out glfw)
lam_add_package_maybe_prebuilt(glfw
  "gh:glfw/glfw#${glfw_TAG}"
  NAME glfw3
  CMAKE_ARGS "-DGLFW_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DGLFW_BUILD_DOCS=OFF"
  CMAKE_ARGS "-DGLFW_INSTALL=${out}"
  # for user customize.
  ${glfw_USER_CUSTOM_ARGS}
)

add_library(glfw::glfw ALIAS glfw)

if (${glfw_DEF_INCLUDE_NONE})
  target_compile_definitions(glfw INTERFACE GLFW_INCLUDE_NONE)
endif()
