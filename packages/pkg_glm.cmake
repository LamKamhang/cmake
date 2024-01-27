include_guard()

# if glm::glm has been found
if (TARGET glm::glm)
  return()
endif()

message(STATUS "[package/glm]: glm::glm")

if (NOT DEFINED glm_VERSION)
  set(glm_VERSION "1.0.0")
endif()

if (NOT DEFINED glm_TAG)
  set(glm_TAG "${glm_VERSION}")
endif()

lam_add_package_maybe_prebuilt(glm
  "gh:g-truc/glm#${glm_TAG}"
  OPTIONS
  "BUILD_TESTING OFF"
  # for user customize.
  ${glm_USER_CUSTOM_ARGS}
)
