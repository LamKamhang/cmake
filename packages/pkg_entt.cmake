include_guard()

# if EnTT::EnTT has been found
if (TARGET EnTT::EnTT)
  return()
endif()

message(STATUS "[package/EnTT]: EnTT::EnTT")


if (NOT DEFINED entt_VERSION)
  set(entt_VERSION "3.12.2")
endif()
if (NOT DEFINED entt_TAG)
  set(entt_TAG "v${entt_VERSION}")
endif()

require_package(EnTT "gh:skypjack/entt#${entt_TAG}")
