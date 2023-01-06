include_guard()

# if EnTT::EnTT has been found
if (TARGET EnTT::EnTT)
  return()
endif()

message(STATUS "[package/EnTT]: EnTT::EnTT")

set(entt_VERSION 3.11.1 CACHE STRING "EnTT customized version")

require_package(EnTT "gh:skypjack/entt#v${entt_VERSION}")
