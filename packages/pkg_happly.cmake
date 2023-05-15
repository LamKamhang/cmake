include_guard()

# if happly::happly has been found
if (TARGET happly::happly)
  return()
endif()

message(STATUS "[package/happly]: happly::happly")

if (NOT DEFINED happly_TAG)
  if (NOT DEFINED happly_VERSION)
    set(happly_TAG "cfa2611")
  else()
    message(FATAL_ERROR "[package/happly] does not support version selection.")
  endif()
endif()

require_package(happly "gh:nmwsharp/happly#${happly_TAG}")

add_library(happly INTERFACE)
add_library(happly::happly ALIAS happly)
target_include_directories(happly INTERFACE ${happly_SOURCE_DIR})
