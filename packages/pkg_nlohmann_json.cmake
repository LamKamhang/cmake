include_guard()

# if nlohmann_json::nlohmann_json has been found
if (TARGET nlohmann_json::nlohmann_json)
  return()
endif()

message(STATUS "[package/nlohmann_json]: nlohmann_json::nlohmann_json")

if (NOT DEFINED nlohmann_json_TAG)
  if (NOT DEFINED nlohmann_json_VERSION)
    set(nlohmann_json_TAG "v3.11.2")
  else()
    set(nlohmann_json_TAG v${nlohmann_json_VERSION})
  endif()
endif()

require_package(nlohmann_json "gh:nlohmann/json#${nlohmann_json_TAG}"
  CMAKE_ARGS "-DJSON_BuildTests=OFF")
