include_guard()

# if glm::glm has been found
if (TARGET glm::glm)
  return()
endif()

message(STATUS "[package/glm]: glm::glm")

if (NOT DEFINED glm_TAG)
  if (NOT DEFINED glm_VERSION)
    set(glm_TAG "47585fd@0.9.9.9") # 0.9.9.9 still on development.
  else()
    set(glm_TAG "${glm_VERSION}")
  endif()
endif()

lam_add_package_maybe_prebuilt(glm
  "gh:g-truc/glm#${glm_TAG}"
  GIT_SHALLOW OFF
  OPTIONS
  "BUILD_TESTING OFF"
  # for user customize.
  ${glm_USER_CUSTOM_ARGS}
)
