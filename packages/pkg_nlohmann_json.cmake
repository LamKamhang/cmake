include_guard()

# if nlohmann_json::nlohmann_json has been found.
if (TARGET nlohmann_json::nlohmann_json)
  return()
endif()

message(STATUS "[package/nlohmann_json]: nlohmann_json::nlohmann_json")

set(nlohmann_json_VERSION 3.11.2 CACHE STRING "nlohmann_json customized version")

require_package(nlohmann_json "gh:nlohmann/json#v${nlohmann_json_VERSION}"
  CMAKE_ARGS "-DJSON_BuildTests=OFF")
