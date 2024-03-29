include_guard()

# if igl::core has been found
if (TARGET igl::core)
  return()
endif()

message(STATUS "[package/libigl]: igl::core")


if (NOT DEFINED libigl_VERSION)
  set(libigl_VERSION "2.5.0")
endif()
if (NOT DEFINED libigl_TAG)
  set(libigl_TAG "v${libigl_VERSION}")
endif()

lam_add_package("gh:libigl/libigl#${libigl_TAG}")
