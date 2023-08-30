include_guard()

# if igl::imgui_fonts has been found
if (TARGET igl::imgui_fonts)
  return()
endif()

message(STATUS "[package/libigl_imgui_fonts]: igl::imgui_fonts")

if (NOT ${libigl_imgui_fonts_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/libigl_imgui_fonts] does not support version selection.")
endif()

if (NOT DEFINED libigl_imgui_fonts_TAG)
  set(libigl_imgui_fonts_TAG "origin/master")
endif()

lam_add_package("gh:libigl/libigl-imgui#${libigl_imgui_fonts_TAG}"
  DOWNLOAD_ONLY YES
  NAME libigl_imgui_fonts
)

add_library(igl_imgui_fonts INTERFACE)
add_library(igl::imgui_fonts ALIAS igl_imgui_fonts)
target_include_directories(igl_imgui_fonts INTERFACE ${libigl_imgui_fonts_SOURCE_DIR})
