include_guard()

# if glad has been found
if (TARGET glad::glad)
  return()
endif()

set(glad_GL_CONFIG core CACHE STRING "OpenGL API core/compatibility")
set_property(CACHE glad_GL_CONFIG PROPERTY STRINGS
  core compatibility
)

message(STATUS "[package/glad]: glad")
enable_language(C)

if (NOT DEFINED glad_VERSION)
  set(glad_VERSION "4.6")
endif()
if (NOT DEFINED glad_TAG)
  set(glad_TAG "gl-${glad_GL_CONFIG}-${glad_VERSION}")
endif()

lam_add_package("gh:LamKamhang/glad#${glad_TAG}")
