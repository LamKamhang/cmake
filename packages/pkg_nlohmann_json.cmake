include_guard()

message(STATUS "[package/nlohmann_json]: nlohmann_json::nlohmann_json")

require_package(nlohmann_json "gh:nlohmann/json#v3.11.2"
  CMAKE_ARGS "-DJSON_BuildTests=OFF")
