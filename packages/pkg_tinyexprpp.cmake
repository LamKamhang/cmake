include_guard()

# if tinyexprpp::tinyexprpp has been found
if (TARGET tinyexprpp::tinyexprpp)
  return()
endif()

message(STATUS "[package/tinyexprpp]: tinyexprpp::tinyexprpp")

if (NOT ${tinyexprpp_VERSION} STREQUAL "")
  message(FATAL_ERROR "[package/tinyexprpp] does not support version selection.")
endif()

if (NOT DEFINED tinyexprpp_TAG)
  set(tinyexprpp_TAG "origin/tinyexpr++")
endif()

lam_check_prefer_prebuilt(out tinyexprpp)
lam_add_package(
  "gh:Blake-Madden/tinyexpr-plusplus#${tinyexprpp_TAG}"
  NAME tinyexprpp
  # for user customize.
  ${tinyexprpp_USER_CUSTOM_ARGS}
)

add_library(tinyexprpp EXCLUDE_FROM_ALL
  ${tinyexprpp_SOURCE_DIR}/tinyexpr.h
  ${tinyexprpp_SOURCE_DIR}/tinyexpr.cpp
)
target_include_directories(tinyexprpp PUBLIC
  $<BUILD_INTERFACE:${tinyexprpp_SOURCE_DIR}>
)
add_library(tinyexprpp::tinyexprpp ALIAS tinyexprpp)
