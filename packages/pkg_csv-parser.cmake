include_guard()

if (TARGET csv)
  return()
endif()

message(STATUS "[package/csv]: csv-parser")

set(csv-parser_VERSION 2.1.3 CACHE STRING "csv-parser customized version")

require_package(csv-parser "gh:vincentlaucsb/csv-parser#${csv-parser_VERSION}")
