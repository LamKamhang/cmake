include_guard()

# if pugixml::pugixml has been found
if (TARGET pugixml::pugixml)
  return()
endif()

message(STATUS "[package/pugixml]: pugixml::pugixml")


if (NOT DEFINED pugixml_VERSION)
  set(pugixml_VERSION "1.14")
endif()
if (NOT DEFINED pugixml_TAG)
  set(pugixml_TAG "v${pugixml_VERSION}")
endif()

lam_add_package_maybe_prebuilt(pugixml
  "gh:zeux/pugixml#${pugixml_TAG}"
  # for user customize.
  ${pugixml_USER_CUSTOM_ARGS}
)
