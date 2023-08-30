include_guard()

# if happly has been found
if (TARGET happly::happly)
  return()
endif()
if (TARGET happly)
  add_library(happly::happly ALIAS happly)
  return()
endif()

message(STATUS "[package/happly]: happly, happly::happly")

if (NOT ${happly_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/happly] does not support version selection.")
endif()

if (NOT DEFINED happly_TAG)
  set(happly_TAG "cfa2611")
endif()

lam_add_package(
  "gh:nmwsharp/happly#${happly_TAG}"
  GIT_SHALLOW OFF
)

add_library(happly INTERFACE)
add_library(happly::happly ALIAS happly)
target_include_directories(happly INTERFACE ${happly_SOURCE_DIR})
