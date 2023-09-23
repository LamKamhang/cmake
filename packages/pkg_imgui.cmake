include_guard()

# if imgui has been found
if (TARGET imgui::imgui)
  return()
endif()
if (TARGET imgui)
  add_library(imgui::imgui ALIAS imgui)
  return()
endif()

message(STATUS "[package/imgui]: imgui")
option(imgui_ENABLE_STDLIB    "Enable InputText() wrappers for STL type: std::string." ON)
option(imgui_ENABLE_FREETYPE  "Build font atlases using FreeType instead of stb_truetype" OFF)

if (NOT DEFINED imgui_VERSION)
  set(imgui_VERSION "1.89.9")
endif()
if (NOT DEFINED imgui_TAG)
  set(imgui_TAG "v${imgui_VERSION}")
endif()

lam_add_package("gh:ocornut/imgui#${imgui_TAG}")

set(imgui_headers
  ${imgui_SOURCE_DIR}/imgui.h
  ${imgui_SOURCE_DIR}/imgui_internal.h
  ${imgui_SOURCE_DIR}/imstb_rectpack.h
  ${imgui_SOURCE_DIR}/imstb_textedit.h
  ${imgui_SOURCE_DIR}/imstb_truetype.h
)
set(imgui_sources
  ${imgui_SOURCE_DIR}/imgui.cpp
  ${imgui_SOURCE_DIR}/imgui_demo.cpp
  ${imgui_SOURCE_DIR}/imgui_draw.cpp
  ${imgui_SOURCE_DIR}/imgui_tables.cpp
  ${imgui_SOURCE_DIR}/imgui_widgets.cpp
)
add_library(imgui EXCLUDE_FROM_ALL)
add_library(imgui::imgui ALIAS imgui)
target_include_directories(imgui PUBLIC
  $<BUILD_INTERFACE:${imgui_SOURCE_DIR}>
)
target_include_directories(imgui PUBLIC
  $<BUILD_INTERFACE:${imgui_SOURCE_DIR}/../>
)
target_include_directories(imgui PUBLIC
  $<BUILD_INTERFACE:${imgui_SOURCE_DIR}/backends/>
)

if (imgui_ENABLE_STDLIB)
  list(APPEND imgui_sources
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.cpp
  )
  list(APPEND imgui_headers
    ${imgui_SOURCE_DIR}/misc/cpp/imgui_stdlib.h
  )
endif()

if (imgui_ENABLE_FREETYPE)
  list(APPEND imgui_sources
    ${imgui_SOURCE_DIR}/misc/freetype/imgui_freetype.cpp
  )
  list(APPEND imgui_headers
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
list(APPEND imgui_sources
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_PLATFORM_BACKEND}.cpp
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_RENDERER_BACKEND}.cpp
)
list(APPEND imgui_headers
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_PLATFORM_BACKEND}.h
  ${imgui_SOURCE_DIR}/backends/imgui_impl_${imgui_RENDERER_BACKEND}.h
)
target_sources(imgui
  PRIVATE ${imgui_sources}
  ${imgui_headers}
)

# add deps.
if (${imgui_PLATFORM_BACKEND} STREQUAL glfw)
  lam_use_deps(glfw)
  target_link_libraries(imgui PUBLIC glfw::glfw)
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
    lam_use_deps(glad)
    target_link_libraries(imgui PUBLIC glad::glad)
  elseif(${imgui_GL_BINDING} STREQUAL glbinding)
    lam_use_deps(glbinding)
    target_link_libraries(imgui PUBLIC glbinding::glbinding)
  endif()
endif()

# message(STATUS "IMGUI: ${imgui_headers}")

foreach(header ${imgui_headers})
  string(REPLACE "${imgui_SOURCE_DIR}/" "" header "${header}")
  lam_install(
    PACKAGE imgui
    TARGETS imgui
    SUFFIX -${imgui_TAG}
    # keep directory structure.
    DIRECTORY ${imgui_SOURCE_DIR}
    EXTRAS_ARGS
    FILES_MATCHING
    PATTERN "examples" EXCLUDE
    PATTERN ".git*" EXCLUDE
    PATTERN "docs" EXCLUDE
    PATTERN ${header}
  )
endforeach()

unset(imgui_headers)
unset(imgui_sources)
