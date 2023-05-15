include_guard()

# if glad has been found
if (TARGET glad::glad)
  return()
endif()

message(STATUS "[package/glad]: glad")
enable_language(C)

if (NOT DEFINED glad_VERSION)
  set(glad_VERSION "4.6")
endif()
if (NOT DEFINED glad_TAG)
  set(glad_TAG "OpenGL-Core-${glad_VERSION}")
endif()

require_package(glad "gh:LamKamhang/glad#${glad_TAG}")
