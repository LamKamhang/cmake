include_guard()

# if pugixml::pugixml has been found
if (TARGET pugixml::pugixml)
  return()
endif()

message(STATUS "[package/pugixml]: pugixml::pugixml")


if (NOT DEFINED pugixml_VERSION)
  set(pugixml_VERSION "1.13")
endif()
if (NOT DEFINED pugixml_TAG)
  set(pugixml_TAG "v${pugixml_VERSION}")
endif()

require_package("gh:zeux/pugixml#${pugixml_TAG}")