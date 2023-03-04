include_guard()

# if imgui has been found.
if (TARGET imgui)
  return()
endif()

message(STATUS "[package/imgui]")

option(imgui_ENABLE_STDLIB   "Enable InputText() wrappers for STL type: std::string." ON)
option(imgui_ENABLE_FREETYPE "Build font atlases using FreeType instead of stb_truetype" OFF)
option(imgui_USE_DOCKING     "Enable Docking Feature" ON)
set(imgui_VERSION 1.89.1 CACHE STRING "imgui customized version, if `DOCKING` is disable.")

if (imgui_USE_DOCKING)
  message(STATUS "Imgui use docking feature.")
  require_package(imgui "gh:ocornut/imgui#c191faf0" DOWNLOAD_ONLY YES)
else()
  require_package(imgui "gh:ocornut/imgui#v${imgui_VERSION}" DOWNLOAD_ONLY YES)
endif()

file(GLOB imgui_root_srcs ${imgui_SOURCE_DIR}/*.h ${imgui_SOURCE_DIR}/*.cpp)
if (imgui_ENABLE_STDLIB)
  set(imgui_misc_srcs
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.cpp
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.h)
endif()

if (imgui_ENABLE_FREETYPE)
  set(imgui_misc_srcs
    ${imgui_SOURCE_DIR}/misc/freetype/imgui_freetype.cpp
    ${imgui_SOURCE_DIR}/misc/freetype/imgui_freetype.h)
endif()

add_library(imgui
  ${imgui_root_srcs}
  ${imgui_misc_srcs}
  # opengl backends
  ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.h
  ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
  ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.h
  ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.cpp)
add_library(imgui::imgui ALIAS imgui)

# deps
declare_pkg_deps(glfw glad)

if (NOT TARGET OpenGL::GL)
  cmake_policy(SET CMP0072 NEW)
  find_package(OpenGL REQUIRED)
endif()

target_link_libraries(imgui PUBLIC glfw glad OpenGL::GL)
target_include_directories(imgui PUBLIC ${imgui_SOURCE_DIR})
target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLAD)
