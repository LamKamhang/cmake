include_guard()

# if imgui has been found
if (TARGET imgui)
  if (NOT TARGET imgui::imgui)
    add_library(imgui::imgui ALIAS imgui)
  endif()
  return()
endif()

message(STATUS "[package/imgui]: imgui")
option(imgui_ENABLE_STDLIB    "Enable InputText() wrappers for STL type: std::string." ON)
option(imgui_ENABLE_FREETYPE  "Build font atlases using FreeType instead of stb_truetype" OFF)
option(imgui_USE_DOCKING      "Enable Docking Feature" OFF)

if (imgui_USE_DOCKING)
  message(STATUS "Imgui use docking feature.")
  set(imgui_TAG "6cc967a")
else()
  if (NOT DEFINED imgui_VERSION)
    set(imgui_VERSION "1.89.7")
  endif()
  if (NOT DEFINED imgui_TAG)
    set(imgui_TAG "v${imgui_VERSION}")
  endif()
endif()

require_package(imgui "gh:ocornut/imgui#${imgui_TAG}")

add_library(imgui
  ${imgui_SOURCE_DIR}/imgui.h
  ${imgui_SOURCE_DIR}/imgui_internal.h
  ${imgui_SOURCE_DIR}/imstb_rectpack.h
  ${imgui_SOURCE_DIR}/imstb_textedit.h
  ${imgui_SOURCE_DIR}/imstb_truetype.h
  ${imgui_SOURCE_DIR}/imgui.cpp
  ${imgui_SOURCE_DIR}/imgui_demo.cpp
  ${imgui_SOURCE_DIR}/imgui_draw.cpp
  ${imgui_SOURCE_DIR}/imgui_tables.cpp
  ${imgui_SOURCE_DIR}/imgui_widgets.cpp
)
add_library(imgui::imgui ALIAS imgui)
target_include_directories(imgui PUBLIC ${imgui_SOURCE_DIR})
target_include_directories(imgui PUBLIC ${imgui_SOURCE_DIR}/../)

if (imgui_ENABLE_STDLIB)
  target_sources(imgui
    PRIVATE
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.cpp
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.h
  )
endif()

if (imgui_ENABLE_FREETYPE)
  target_sources(imgui
    PRIVATE
    ${imgui_SOURCE_DIR}/misc/freetype/imgui_freetype.cpp
    ${imgui_SOURCE_DIR}/misc/freetype/imgui_freetype.h
  )
  target_compile_definitions(imgui PUBLIC IMGUI_ENABLE_FREETYPE)
endif()

# backends.
set(imgui_PLATFORM_BACKEND glfw CACHE STRING "imgui Platforms backend")
set(imgui_RENDERER_BACKEND opengl3 CACHE STRING "imgui Renderer backend")
set_property(CACHE imgui_PLATFORM_BACKEND PROPERTY STRINGS
  glfw android sdl2 win32
)
set_property(CACHE imgui_RENDERER_BACKEND PROPERTY STRINGS
  dx9 dx10 dx11 dx12 opengl3 sdlrenderer2 sdlrenderer3 vulkan wgpu
)

# add backends sources.
target_sources(imgui
  PRIVATE
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_PLATFORM_BACKEND}.h
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_PLATFORM_BACKEND}.cpp
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_RENDERER_BACKEND}.h
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_RENDERER_BACKEND}.cpp
)

# add deps.
if (${imgui_PLATFORM_BACKEND} STREQUAL glfw)
  declare_pkg_deps(glfw)
  target_link_libraries(imgui PUBLIC glfw)
endif()

if (${imgui_RENDERER_BACKEND} STREQUAL opengl3)
  if (NOT TARGET OpenGL::GL)
    cmake_policy(SET CMP0072 NEW)
    find_package(OpenGL REQUIRED)
    target_link_libraries(imgui PUBLIC OpenGL::GL)
  endif()
  set(imgui_GL_BINDING glbinding CACHE STRING "OpenGL API")
  set_property(CACHE imgui_GL_BINDING PROPERTY STRINGS
    glad glbinding
  )
  if (${imgui_GL_BINDING} STREQUAL glad)
    declare_pkg_deps(glad)
    target_link_libraries(imgui PUBLIC glad)
  elseif(${imgui_GL_BINDING} STREQUAL glbinding)
    declare_pkg_deps(glbinding)
    target_link_libraries(imgui PUBLIC glbinding::glbinding)
  endif()
endif()
