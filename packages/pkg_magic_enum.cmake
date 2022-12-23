include_guard()

# if magic_enum::magic_enum has been found
if (TARGET magic_enum::magic_enum)
  return()
endif()

message(STATUS "[package/magic_enum]: magic_enum::magic_enum")

set(MAGIC_ENUM_VERSION 0.8.2 CACHE STRING "magic_enum customized version")

require_package(magic_enum "gh:Neargye/magic_enum.git#v${MAGIC_ENUM_VERSION}"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_TESTS=OFF")
