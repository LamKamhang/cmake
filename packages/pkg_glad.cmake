include_guard()

# if glad has been found.
if (TARGET glad::glad)
  return()
endif()

message(STATUS "[package/glad]: glad::glad")

enable_language(C)

require_package(glad "gh:LamKamhang/glad#OpenGL-Core-4.6" SUBDIR_ONLY DOWNLOAD_ONLY)
