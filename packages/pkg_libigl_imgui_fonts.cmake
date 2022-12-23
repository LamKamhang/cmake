include_guard()

# if igl::imgui_fonts has been found.
if (TARGET igl::imgui_fonts)
  return()
endif()

message(STATUS "[package/libigl-imgui]: igl::imgui_fonts")

require_package(libigl_imgui "gh:libigl/libigl-imgui#origin/master" DOWNLOAD_ONLY)
add_library(igl_imgui_fonts INTERFACE)
add_library(igl::imgui_fonts ALIAS igl_imgui_fonts)
target_include_directories(igl_imgui_fonts INTERFACE ${libigl_imgui_SOURCE_DIR})
