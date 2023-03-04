include_guard()

# if glad has been found.
if (TARGET glad::glad)
  return()
endif()

message(STATUS "[package/glad]: glad::glad")

enable_language(C)
set(glad_VERSION OpenGL-Core-4.6 CACHE STRING "glad customized version")

require_package(glad "gh:LamKamhang/glad#${glad_VERSION}")
