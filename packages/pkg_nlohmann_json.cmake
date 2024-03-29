include_guard()

# if nlohmann_json::nlohmann_json has been found
if (TARGET nlohmann_json::nlohmann_json)
  return()
endif()

message(STATUS "[package/nlohmann_json]: nlohmann_json::nlohmann_json")

if (NOT DEFINED nlohmann_json_VERSION)
  set(nlohmann_json_VERSION "3.11.3")
endif()
if (NOT DEFINED nlohmann_json_TAG)
  set(nlohmann_json_TAG "v${nlohmann_json_VERSION}")
endif()

lam_add_package_maybe_prebuilt(nlohmann_json
  "gh:nlohmann/json#${nlohmann_json_TAG}"
  NAME nlohmann_json
  CMAKE_ARGS "-DJSON_BuildTests=OFF"
  # for user customize.
  ${nlohmann_json_USER_CUSTOM_ARGS}
)
