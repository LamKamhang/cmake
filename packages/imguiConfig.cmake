if (NOT DEFINED IMGUI_DIR)
  set(IMGUI_DIR ${PROJECT_SOURCE_DIR}/3rd/imgui_wrapper)
endif()

if (EXISTS ${IMGUI_DIR})
  message(STATUS "imgui_wrapper find: ${IMGUI_DIR}")
  if (NOT TARGET imgui)
    set(source
      ${IMGUI_DIR}/imgui/imgui.cpp
      ${IMGUI_DIR}/imgui/imgui_demo.cpp
      ${IMGUI_DIR}/imgui/imgui_draw.cpp
      ${IMGUI_DIR}/imgui/imgui_tables.cpp
      ${IMGUI_DIR}/imgui/imgui_widgets.cpp
      ${IMGUI_DIR}/imgui/backends/imgui_impl_opengl3.cpp
      ${IMGUI_DIR}/imgui/backends/imgui_impl_glfw.cpp
      )

    set(header
      ${IMGUI_DIR}/imgui/imconfig.h
      ${IMGUI_DIR}/imgui/imgui.h
      ${IMGUI_DIR}/imgui/imgui_internal.h
      ${IMGUI_DIR}/imgui/imstb_rectpack.h
      ${IMGUI_DIR}/imgui/imstb_textedit.h
      ${IMGUI_DIR}/imgui/imstb_truetype.h)

    add_library(imgui ${source} ${header})

    if (NOT TARGET glfw)
      find_package(glfw3 REQUIRED)
    endif()

    if (NOT TARGET glad)
      find_package(glad REQUIRED)
    endif()

    if (NOT TARGET OpenGL::GL)
      cmake_policy(SET CMP0072 NEW)
      find_package(OpenGL REQUIRED)
    endif()

    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLAD)

    target_include_directories(imgui
      PUBLIC
      ${IMGUI_DIR}/
      ${IMGUI_DIR}/imgui/
      ${IMGUI_DIR}/imgui/backends
      )

    target_link_libraries(imgui PUBLIC glfw glad OpenGL::GL)
  endif()
  set(imgui_FOUND TRUE)
else()
  message(WARNING "imgui_wrapper not found! please set {IMGUI_DIR} correctly!")
  set(imgui_FOUND FALSE)
endif()
