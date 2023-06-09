include_guard()

# if magic_enum::magic_enum has been found
if (TARGET magic_enum::magic_enum)
  return()
endif()

message(STATUS "[package/magic_enum]: magic_enum::magic_enum")


if (NOT DEFINED magic_enum_VERSION)
  set(magic_enum_VERSION "0.9.1")
endif()
if (NOT DEFINED magic_enum_TAG)
  set(magic_enum_TAG "v${magic_enum_VERSION}")
endif()

require_package(magic_enum "gh:Neargye/magic_enum.git#${magic_enum_TAG}"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_TESTS=OFF")
