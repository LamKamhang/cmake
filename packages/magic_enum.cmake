include_guard()

message(STATUS "[package/magic_enum]: magic_enum::magic_enum")

require_package(magic_enum "gh:Neargye/magic_enum.git#v0.8.2"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DMAGIC_ENUM_OPT_BUILD_TESTS=OFF")
