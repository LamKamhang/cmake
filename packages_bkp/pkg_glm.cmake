include_guard()

# if glm::glm has been found
if (TARGET glm::glm)
  return()
endif()

message(STATUS "[package/glm]: glm::glm")

if (NOT DEFINED glm_TAG)
  if (NOT DEFINED glm_VERSION)
    set(glm_TAG "5c46b9c@0.9.9.9") # 0.9.9.9 still on development.
  else()
    set(glm_TAG "${glm_VERSION}")
  endif()
endif()

require_package("gh:g-truc/glm#${glm_TAG}")
