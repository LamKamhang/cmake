include_guard()

# if glbinding::glbinding has been found
if (TARGET glbinding::glbinding)
  return()
endif()

message(STATUS "[package/glbinding]: glbinding::glbinding")


if (NOT DEFINED glbinding_VERSION)
  set(glbinding_VERSION "3.3.0")
endif()
if (NOT DEFINED glbinding_TAG)
  set(glbinding_TAG "v${glbinding_VERSION}")
endif()

require_package(glbinding "gh:cginternals/glbinding#${glbinding_TAG}"
  CMAKE_ARGS "-DOPTION_SELF_CONTAINED=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_DOCS=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_TOOLS=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_WITH_BOOST_THREAD=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_CHECK=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_OWN_KHR_HEADERS=OFF"
  CMAKE_ARGS "-DOPTION_BUILD_WITH_LTO=ON"
  CMAKE_ARGS "-DOPTION_USE_GIT_INFORMATION=OFF"
)
