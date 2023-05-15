include_guard()

# if EnTT::EnTT has been found
if (TARGET EnTT::EnTT)
  return()
endif()

message(STATUS "[package/EnTT]: EnTT::EnTT")

if (NOT DEFINED entt_TAG)
  if (NOT DEFINED entt_VERSION)
    set(entt_TAG "v3.11.1")
  else()
    set(entt_TAG v${entt_VERSION})
  endif()
endif()

require_package(EnTT "gh:skypjack/entt#${entt_TAG}")
