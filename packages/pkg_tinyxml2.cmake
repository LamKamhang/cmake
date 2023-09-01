include_guard()

# if tinyxml2::tinyxml2 has been found
if (TARGET tinyxml2::tinyxml2)
  return()
endif()

message(STATUS "[package/tinyxml2]: tinyxml2::tinyxml2")

if (NOT DEFINED tinyxml2_VERSION)
  set(tinyxml2_VERSION "9.0.0")
endif()
if (NOT DEFINED tinyxml2_TAG)
  set(tinyxml2_TAG "${tinyxml2_VERSION}")
endif()

lam_add_package_maybe_prebuild(
  "gh:leethomason/tinyxml2#${tinyxml2_TAG}"
  CMAKE_ARGS "-Dtinyxml2_BUILD_TESTING=OFF"
  # for user customize.
  ${tinyxml2_USER_CUSTOMIZE_ARGS}
)
