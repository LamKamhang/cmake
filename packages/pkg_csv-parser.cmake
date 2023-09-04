include_guard()

# if csv has been found
if (TARGET csv)
  return()
endif()

message(STATUS "[package/csv-parser]: csv")


if (NOT DEFINED csv-parser_VERSION)
  set(csv-parser_VERSION "2.1.3")
endif()
if (NOT DEFINED csv-parser_TAG)
  set(csv-parser_TAG "${csv-parser_VERSION}")
endif()

lam_add_package(
  "gh:vincentlaucsb/csv-parser#${csv-parser_TAG}"
  NAME csv-parser
  # for user customize.
  ${csv-parser_USER_CUSTOM_ARGS}
)
target_include_directories(csv PUBLIC
  ${csv-parser_SOURCE_DIR}/include
)
