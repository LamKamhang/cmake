include_guard()

# if stb::stb has been found
if (TARGET stb::stb)
  return()
endif()

message(STATUS "[package/stb]: stb::stb")

if (NOT ${stb_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/stb] does not support version selection.")
endif()

if (NOT DEFINED stb_TAG)
  set(stb_TAG "5736b15@")
endif()

require_package(stb "gh:nothings/stb#${stb_TAG}"
  DOWNLOAD_ONLY YES
)

function(make_stb_target target_name)
  # suppose that the source is stb_${target_name}.h
  set(header_file "stb_${target_name}.h")
  set(source_file "stb_${target_name}.cpp")
  set(full_target_name "stb_${target_name}")
  set(target_alias "stb::${target_name}")
  string(TOUPPER "${target_name}" TARGET_NAME_UPPER)
  set(macro_definition STB_${TARGET_NAME_UPPER}_IMPLEMENTATION)

  # create source file.
  file(WRITE "${stb_BINARY_DIR}/${source_file}"
    "#define ${macro_definition}\n#include <${header_file}>\n"
  )
  # create library.
  add_library(${full_target_name} EXCLUDE_FROM_ALL
    "${stb_BINARY_DIR}/${source_file}"
  )
  add_library(${target_alias} ALIAS ${full_target_name})
  set_target_properties(${full_target_name} PROPERTIES POSITION_INDEPENDENT_CODE ON)
  target_include_directories(${full_target_name} PUBLIC
    $<BUILD_INTERFACE:${stb_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
endfunction()

set(stb_targets
  hexwave image image_resize image_write
  truetype rect_pack perlin ds easy_font
  herringbone_wang_tile c_lexer divide
  leakcheck include
)

add_library(stb_all INTERFACE)
add_library(stb::stb ALIAS stb_all)

foreach(target ${stb_targets})
  make_stb_target(${target})
  target_link_libraries(stb_all INTERFACE stb::${target})
endforeach()

unset(make_stb_target)
